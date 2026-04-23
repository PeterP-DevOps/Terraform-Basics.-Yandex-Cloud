locals {
  vm_web_full_name = "${var.vm_web_name}-${var.vm_web_platform_id}-${var.vms_resources.web.cores}"
  vm_db_full_name  = "${var.vm_db_name}-${var.vm_db_platform_id}-${var.vms_resources.db.cores}"
}
