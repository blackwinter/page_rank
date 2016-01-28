#--
###############################################################################
#                                                                             #
# page_rank -- PageRank implementation for Ruby                               #
#                                                                             #
# Copyright (C) 2016 Jens Wille                                               #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# page_rank is free software; you can redistribute it and/or modify it under  #
# the terms of the GNU Affero General Public License as published by the Free #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# page_rank is distributed in the hope that it will be useful, but WITHOUT    #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License #
# for more details.                                                           #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with page_rank. If not, see <http://www.gnu.org/licenses/>.           #
#                                                                             #
###############################################################################
#++

require 'gsl'
require 'json'
require 'forwardable'
require 'nuggets/hash/idmap'
require 'nuggets/array/correlation'

class PageRank

  include Enumerable

  extend Forwardable

  DEFAULT_CONVERGENCE = 1e-8

  DEFAULT_MAX_ITERATIONS = 1000

  DEFAULT_DAMPING_FACTOR = 0.85

  class << self

    def from_hash(hash, *args)
      s = hash.to_a.flatten.uniq
      new(s.size, *args).seed(s.sort_by { |k| sortkey(k) }) << hash
    end

    def from_json(path, *args)
      from_hash(JSON.parse(File.read(path)), *args)
    end

    private

    def sortkey(k)
      Float(k)
    rescue TypeError, ArgumentError
      k
    end

  end

  def initialize(size, options = {})
    @size, @idmap, @matrix, @iterations, @ranking, @divergence =
      size, Hash.idmap(-1), GSL::Matrix.zeros(size), 0, [], []

    @dangling_nodes, @initialization_vector =
      GSL::Vector::Col.alloc(size).set_all(1),
      GSL::Vector::Col.alloc(size).set_all(Rational(1, size))

    @convergence    = options.fetch(:convergence,    DEFAULT_CONVERGENCE)
    @max_iterations = options.fetch(:max_iterations, DEFAULT_MAX_ITERATIONS)
    @damping_factor = options.fetch(:damping_factor, DEFAULT_DAMPING_FACTOR)
  end

  attr_reader :size, :iterations, :ranking, :divergence

  attr_reader :matrix, :dangling_nodes, :initialization_vector

  attr_accessor :convergence, :max_iterations, :damping_factor

  def_delegator :@idmap, :[], :id

  def_delegator :@idmap, :size, :count

  def_delegator :@idmap, :keys, :nodes

  def_delegators :@idmap, :key, :empty?

  private :id, :key

  def inspect
    s = '#<%s:0x%x>' % [self.class, object_id]

    %w[size count convergence max_iterations damping_factor].each { |v|
      s.insert(-2, " @#{v}=#{send(v).inspect}")
    }

    s
  end

  def seed(list)
    list.each { |k| id(k) }
    self
  end

  def <<(hash)
    hash.each { |k, v| self[k] = v }
    self
  end

  def []=(k, v)
    w = Rational(1, v.size)
    dangling_nodes[i = id(k)] = 0
    v.each { |l| matrix[i, id(l)] = w }
  end

  def rank(personalization = true)
    iv, v = initialization_vector.dup, personalization

    order(iterate(case v
      when true    then iv
      when 0       then iv.set_zero
      when Float   then iv.set_all(v)
      when Integer then iv.set_all(Rational(1, v))
      else              v
    end)) unless empty?
  end

  def each
    return enum_for(__method__) unless block_given?

    index = -1

    matrix.each_row { |r|
      k, v = index += 1, r.where.to_a
      yield key(k), v.map! { |l| key(l) }.sort! unless v.empty?
    }

    self
  end

  def to_json
    JSON.fast_generate(to_h)
  end

  def to_table
    matrix.to_a.map.with_index { |r, i| [key(i) || i + 1,
      r.map.with_index { |v, j| [key(j) || j + 1, v] }] }
  end

  private

  # pv ? Langville/Meyer 2012 : Page/Brin 1998
  def iterate(pv)
    iter, prev, diff = [], initialization_vector.trans, @divergence = []

    d, dn = 1 - df = damping_factor, dangling_nodes
    d /= size.to_f unless pv

    max_iterations.times {
      curr = df * prev * matrix
      iter << curr += pv ? (df * prev * dn + d) * pv : d

      diff << [delta = (curr - prev).asum]
      delta < convergence ? break : prev = curr
    }

    @iterations = iter.size

    iter
  end

  def order(iter)
    order, ranking, prev = [], @ranking = [], @idmap.to_a

    iter.each { |t|
      ranking << prev = @idmap.map { |k, i| [k, i, t[i]] }
        .sort_by { |k, _, v| [-v, prev.index(prev.assoc(k))] } }

    prev = prev.map { |k, i,| order << k; i }

    @divergence.zip(ranking) { |diff, rank|
      diff << prev.zip(rank.map { |r| r.delete_at(1) }).corr }

    order
  end

end

require_relative 'page_rank/version'
