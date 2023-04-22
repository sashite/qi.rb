require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'qi'
require 'fix'

Fix.describe Qi::Store do
  on :new, 8 do
    on :cells do
      it { MUST eql [nil, nil, nil, nil, nil, nil, nil, nil] }
    end

    on :deleted_content do
      it { MUST be_nil }
    end

    on :call, 2, 3, 'p' do
      on :cells do
        it { MUST eql [nil, nil, nil, 'p', nil, nil, nil, nil] }
      end

      on :deleted_content do
        it { MUST be_nil }
      end

      on :call, 2, 4, 'K' do
        on :cells do
          it { MUST eql [nil, nil, nil, 'p', 'K', nil, nil, nil] }
        end

        on :deleted_content do
          it { MUST be_nil }
        end

        on :call, 3, 4, 'p' do
          on :cells do
            it { MUST eql [nil, nil, nil, nil, 'p', nil, nil, nil] }
          end

          on :deleted_content do
            it { MUST eql 'K' }
          end
        end
      end
    end
  end
end
