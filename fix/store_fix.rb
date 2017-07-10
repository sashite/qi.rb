require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'qi'
require 'fix'

Fix.describe Qi::Store do
  on :new, 8 do
    on :to_a do
      it { MUST eql [nil, nil, nil, nil, nil, nil, nil, nil] }
    end

    on :call, 44, 3, 'p' do
      it { MUST raise_exception ArgumentError }
    end

    on :call, 2, 444, 'p' do
      it { MUST raise_exception ArgumentError }
    end

    on :captured do
      it { MUST be_nil }
    end

    on :call, 2, 3, 'p' do
      on :to_a do
        it { MUST eql [nil, nil, nil, 'p', nil, nil, nil, nil] }
      end

      on :captured do
        it { MUST be_nil }
      end

      on :call, 2, 4, 'K' do
        on :to_a do
          it { MUST eql [nil, nil, nil, 'p', 'K', nil, nil, nil] }
        end

        on :captured do
          it { MUST be_nil }
        end

        on :call, 3, 4, 'p' do
          on :to_a do
            it { MUST eql [nil, nil, nil, nil, 'p', nil, nil, nil] }
          end

          on :captured do
            it { MUST eql 'K' }
          end
        end
      end
    end
  end
end
