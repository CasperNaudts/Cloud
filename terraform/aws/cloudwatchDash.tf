resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "ec2-dashboard"

  dashboard_body = <<EOF
 {
   "widgets": [
       {
          "type":"metric",
          "x":0,
          "y":0,
          "width":12,
          "height":6,
          "properties":{
             "metrics":[
                [
                   "AWS/EC2",
                   "CPUUtilization",
                   "InstanceId",
                   "${aws_instance.weba1.id}"
                ],
                [
                   "AWS/EC2",
                   "CPUUtilization",
                   "InstanceId",
                   "${aws_instance.webb1.id}"
                ],
                [
                   "AWS/EC2",
                   "CPUUtilization",
                   "InstanceId",
                   "${aws_instance.webc1.id}"
                ]
             ],
             "period":300,
             "stat":"Average",
             "region":"us-east-1",
             "title":"EC2 Instance CPU"
          }
       },
       {
          "type":"text",
          "x":0,
          "y":7,
          "width":3,
          "height":3,
          "properties":{
             "markdown":"TADADADADADA"
          }
       }
   ]
 }
 EOF
}