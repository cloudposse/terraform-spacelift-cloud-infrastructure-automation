locals {
  _role_binding_ids = {
    "gbl-corp-guests-guest-engagement" = "01KT1DPHR76EVVYTC82Z5QRPK5"
    "gbl-corp-hospitality-menu" = "01KT1DPHS89GCBP0E3F1YRG02X"
    "gbl-corp-information-technology-internal-product" = "01KT1DP7QB3RYDCVPYQT7EBP2H"
    "gbl-corp-information-technology-systems-integrations" = "01KT1DQDYSM8KSSY1QNXBVAEES"
    "gbl-corp-infrastructure" = "01KT1DPFWDTGG9SBYZ0Q6JBQBH"
    "gbl-corp-infrastructure-appointments" = "01KT1DPGCSR60HF7BQ0W3BHA2W"
    "gbl-corp-infrastructure-client-environments" = "01KT1DPHW5MXDNA9H3QVCZ2AJZ"
    "gbl-corp-infrastructure-cloud-and-traffic" = "01KT1MQSREKMCB098ER7FZHTW3"
    "gbl-corp-infrastructure-cloud-and-traffic-test" = "01KT1DPGE1AJ0MACR53QYC9JNN"
    "gbl-corp-infrastructure-cloud-orphan" = "01KT1DQEF16W6WEQC18MXC32H7"
    "gbl-corp-infrastructure-compute-platform" = "01KT1DRH4QRDW60BFBVDY0HDAQ"
    "gbl-corp-infrastructure-core-backend" = "01KT1DQC6E1DDEK7KAPBS0M895"
    "gbl-corp-infrastructure-core-frontend" = "01KT1DPG9FH7FFY3N63W3SR6Q0"
    "gbl-corp-infrastructure-core-web-platform" = "01KT1DPHPH4NPKES7W900VBXNC"
    "gbl-corp-infrastructure-customer-service" = "01KT1DPGCKXHME2B6EXHD407CA"
    "gbl-corp-infrastructure-dana" = "01KT1DQS7MYJP7DSEHR59AX8SJ"
    "gbl-corp-infrastructure-data-platform" = "01KT1DQDXM8BHAY5TQB8421RMW"
    "gbl-corp-infrastructure-delivery-platform" = "01KT1DPGYG6EQ7R09J8QDXDRNZ"
    "gbl-corp-infrastructure-device-management" = "01KT1DRK0PB6S547B3NGR0ZPDH"
    "gbl-corp-infrastructure-enterprise" = "01KT1DPHPC2SANF691VK489CKY"
    "gbl-corp-infrastructure-express" = "01KT1DPWEA0RQFVARD1S07R9HC"
    "gbl-corp-infrastructure-flex" = "01KT1DQEAPRH18BTNW0BCWMY7N"
    "gbl-corp-infrastructure-growth" = "01KT1DPHPXFK2RZEC82Z87HH7F"
    "gbl-corp-infrastructure-guests-guest-scheduling" = "01KT1DPGD0JRPTYXAA0PFYWWJ1"
    "gbl-corp-infrastructure-hub" = "01KT1DPX3CW43P93HH325NXZPA"
    "gbl-corp-infrastructure-it-qa-automation" = "01KT1DPGK1DKQYH6TDHHRW39B2"
    "gbl-corp-infrastructure-it-sys-eng" = "01KT1DPPT80FZQQWDSTSYTRWCZ"
    "gbl-corp-infrastructure-kitchen-manager" = "01KT1DPGBZGQ2VPFYZJ71BWKNA"
    "gbl-corp-infrastructure-marketing-as-a-service" = "01KT1DPHRD7FA1T7FPBARB3ZF5"
    "gbl-corp-infrastructure-merchant-dashboard-backend" = "01KT1DRK09TECFH05P6YZJ9492"
    "gbl-corp-infrastructure-merchant-dashboard-frontend" = "01KT1DPQ9PY8YWGRCZ5XK9V3ZW"
    "gbl-corp-infrastructure-omnichannel" = "01KT1DPH63AEYED89822DR9MG0"
    "gbl-corp-infrastructure-online-ordering" = "01KT1DQW78D209ENT9YWDMYTYD"
    "gbl-corp-infrastructure-payment-operations" = "01KT1DQW5PYK6YAS61VHB8DGG1"
    "gbl-corp-infrastructure-payments" = "01KT1DPX3KTBCK03RPED1VKM26"
    "gbl-corp-infrastructure-reserve" = "01KT1DPS9KTZTT2JQS3Z7ANA4Z"
    "gbl-corp-infrastructure-restaurant-reporting" = "01KT1DPHX7M3V1Y835QVY7EJX3"
    "gbl-corp-infrastructure-restaurants" = "01KT1DPH1HPAK9QNXYMH0GMEYX"
    "gbl-corp-infrastructure-retail-catalog" = "01KT1DPGCC5ARGEJJQ4RYNZ5SS"
    "gbl-corp-infrastructure-retail-integrations" = "01KT1DQE46S52C8HNZK170VSTK"
    "gbl-corp-infrastructure-sales-comp" = "01KT1DPHQF2TX2GN6ZDN7VAZ9M"
    "gbl-corp-infrastructure-streaming-and-observability" = "01KT1DPHXTJAWQ76SSF4FJP8VC"
    "gbl-corp-infrastructure-teamwork" = "01KT1DQDVBMDB14K8P277X4HM4"
    "gbl-corp-infrastructure-thespot" = "01KT1DPHQWG9S54G8NF88EPTD9"
    "gbl-corp-infrastructure-virtual-terminal" = "01KT1DPGPEHQ4JZ3D3W1WGPBCM"
    "gbl-corp-infrastructure-wallet" = "01KT1DPWAWBZ0R7TVZ9G0YT7PC"
    "gbl-corp-infrastructure-websites" = "01KT1DQE4KCAJB2ZSA7X7HJQB8"
    "gbl-corp-merchant-business-owner-command-center" = "01KT1DQ7YS3VRGWH4BRG9W4VNG"
    "gbl-corp-merchant-business-owner-insights" = "01KT1DQW7E62ACME6B993EERTK"
    "gbl-corp-merchant-business-owner-reporting" = "01KT1DPHWBKGPD2Q2G6BZFY2DN"
    "gbl-corp-partnerships" = "01KT1DPX22E8AEKSTJAN05K9RD"
    "gbl-corp-payments-disbursement" = "01KT1DPHP546YJ30S63XBS93VG"
    "gbl-corp-payments-lending" = "01KT1DN62EVMX04ATNCTWQMG4P"
    "gbl-corp-security-infrastructure-security" = "01KT1DQBAR60Z7CS4GZQ0W2KXP"
    "gbl-corp-security-infrastructure-security-compliance-a" = "01KT1DQEA1ERA9HM587XY4P5DX"
    "gbl-corp-security-infrastructure-security-compliance-c-g-s" = "01KT1DPX1AZ0BV7Z0RVYHGD1F4"
    "gbl-corp-security-infrastructure-security-compliance-e" = "01KT1DQE35TP6HWH48FDF5726X"
    "gbl-corp-security-infrastructure-security-compliance-u" = "01KT1DPS3ADXWKB2JBN7JTZ8NN"
  }
}

import {
  for_each = {
    for k, v in local.spacelift_stacks :
    k => local._role_binding_ids[k]
    if try(v.settings.spacelift.administrative, false) && contains(keys(local._role_binding_ids), k)
  }
  id = each.value
  to = module.stacks[each.key].spacelift_role_attachment.admin[0]
}
