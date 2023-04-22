require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'qi'
require 'fix'

Fix.describe Qi::Store do
  on :new, 8 do
    on :cells do
      it { MUST eql [nil, nil, nil, nil, nil, nil, nil, nil] }
    end

    on :call, 2, 3, 'p' do
      on :store do
        on :cells do
          it { MUST eql [nil, nil, nil, 'p', nil, nil, nil, nil] }
        end
      end

      on :deleted_content do
        it { MUST be_nil }
      end
    end
  end
end
