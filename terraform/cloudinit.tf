# cloud-init for workers
data "cloudinit_config" "worker" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "worker.sh"
    content_type = "text/x-shellscript"
    # https://github.com/oracle-terraform-modules/terraform-oci-oke/blob/9561e1ac70460335ae9e6d03ab73d503185d1d78/modules/oke/cloudinit/worker.template.sh
    content      = <<-EOT
        #!/bin/bash

        # DO NOT MODIFY
        curl --fail -H "Authorization: Bearer Oracle" -L0 http://169.254.169.254/opc/v2/instance/metadata/oke_init_script | base64 --decode >/var/run/oke-init.sh

        ## run oke provisioning script
        bash -x /var/run/oke-init.sh

        ### adjust block volume size
        /usr/libexec/oci-growfs -y

        touch /var/log/oke.done
    EOT
  }

}
