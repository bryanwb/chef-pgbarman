name             "pgbarman"
maintainer       "Bryan W. Berry"
maintainer_email "bryan.berry@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures pgbarman"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ yum yumrepo postgresql sudo mail_alias }.each do |ckbk|
  depends ckbk
end
