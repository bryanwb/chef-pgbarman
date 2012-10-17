name             "pgbarman"
maintainer       "YOUR_NAME"
maintainer_email "YOUR_EMAIL"
license          "Apache 2.0"
description      "Installs/Configures pgbarman"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ yum yumrepo postgresql sudo }.each do |ckbk|
  depends ckbk
end
