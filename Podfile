platform :ios, '10.0'


def app_pods
      pod 'TaCoPopulator', :git => 'https://gitlab.com/vikingosegundo/TaCoPopulator.git', :tag => '0.1.5'
end
def test_pods
    pod 'Quick', '~> 1.1'
    pod 'Nimble', '~> 6.0'
end

target 'TrackMe' do
  use_frameworks!
  app_pods
  target 'TrackMeTests' do
      test_pods
  end
end
