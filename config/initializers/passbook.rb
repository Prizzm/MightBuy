Passbook.configure do |passbook|

  passbook.wwdc_cert = Rails.root.join('passbook/certs/AppleWWDRCA.cer')
 
  # Path to your cert.p12 file
  passbook.p12_cert = Rails.root.join("passbook/certs/cert.p12")
  
  # Password for your certificate
  passbook.p12_password = 'moc.mzzirp'
end