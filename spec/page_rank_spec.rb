describe PageRank do

  describe 'empty' do

    subject { described_class.new(23) }

    example { expect(subject.size).to eq(23) }
    example { expect(subject.count).to be_zero }
    example { expect(subject.iterations).to be_zero }

    example { expect(subject).to be_empty }
    example { expect(subject.nodes).to be_empty }
    example { expect(subject.ranking).to be_empty }
    example { expect(subject.divergence).to be_empty }

    example { expect(subject.rank).to be_nil }

  end

  describe 'JSON' do

    def load_file(file, *args)
      described_class.from_json(file, *args)
    end

    {
      1 => %w[4 6 5 2 3 1],
      2 => %w[6 4 5 1 2 3],
      3 => %w[6 3 5 1 2 4],
      4 => %w[1 10 2 6 4 8 3 5 9 7]
    }.each { |k, v|
      f = File.join(File.dirname(__FILE__), 'data', 'test-%d.json' % k)

      example { expect(load_file(f).rank).to eq(v) }
      example { expect(load_file(f).rank(nil)).to eq(v) }

      example { expect(load_file(f).size).to eq(v.size) }
      example { expect(load_file(f).nodes).to eq(v.sort_by(&:to_i)) }

      example { expect(load_file(f).to_json).to eq(File.read(f).chomp) }
    }

  end

end
