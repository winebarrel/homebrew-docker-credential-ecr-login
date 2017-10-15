require 'formula'
require 'tmpdir'

class DockerCredentialEcrLogin < Formula
  VERSION = '1614bf09f10aaa1995647a631ba0f28536d8e417'

  homepage 'https://github.com/awslabs/amazon-ecr-credential-helper'
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/#{VERSION}.tar.gz"
  sha256 '4eb1605b7fba6d536bcea083dc790d7c6c7858541112a9848f20eeeee066d622'
  version VERSION
  head 'https://github.com/awslabs/amazon-ecr-credential-helper.git', :branch => 'master'
  depends_on 'go' => :build

  def install
    Dir.mktmpdir('docker-credential-ecr-login') do |tmp_dir|
      ENV['GOPATH'] = tmp_dir
      ENV['PATH'] = [File.join(tmp_dir, 'bin'), ENV['PATH']].join(':')
      pkg_dir = File.join(tmp_dir, 'src/github.com/awslabs/amazon-ecr-credential-helper')

      system 'mkdir', '-p', File.dirname(pkg_dir)
      system 'ln', '-s', Dir.pwd, pkg_dir
      system "cd #{pkg_dir} && make"
      bin.install 'bin/local/docker-credential-ecr-login'
    end
  end

  def caveats
    <<-EOS.undent
      Set the contents of your ~/.docker/config.json file to be:

      {
          "credsStore": "ecr-login"
      }

    EOS
  end
end
