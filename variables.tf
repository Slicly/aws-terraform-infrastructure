# Preconfigured Amazon Linux AMI containing Apache
variable "web_ami_id" {
  description = "AMI ID for a preconfigured web server with Apache installed"
  type        = string
  default     = "ami-placeholder"

  validation {
    condition     = can(regex("^ami-[0-9a-f]{8,17}$", var.web_ami_id)) || var.web_ami_id == "ami-placeholder"
    error_message = "Enter a valid AMI ID or keep the placeholder for local validation."
  }
}
