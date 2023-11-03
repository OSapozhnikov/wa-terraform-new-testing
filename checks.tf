check "public_ip_assign" {
  data "aws_instance" "demo" {
    instance_id = aws_instance.wa_demo.id
  }

  assert {
    condition     = data.aws_instance.demo.public_ip != null
    error_message = "ERROR: EC2 instance must to have a public IP"
  }
}

# check "service_response" {
#     data "http" "service_response" {
#         url = "https://web-academy.ua/"
#     }

#     assert {
#         condition = data.http.service_response.status_code == 200
#         error_message = "${data.http.service_response.url} returned an unhealthy status code"
#     }
# }