
#Creacion del Lider
resource "aws_instance" "lider" {
	ami = "ami-0bbe28eb2173f6167" # ubuntu AMI (free tier)
	instance_type = "t2.micro"
	subnet_id = "subnet-5c078810"
	vpc_security_group_ids = ["sg-1d736579"]
	user_data = file("files/lider.sh")
	key_name = "ALD"
	tags = {
        Name = "Lider"
	}
}



#Creacion de los Managers

resource "aws_instance" "manager" {
        ami     = "ami-0bbe28eb2173f6167" # ubuntu AMI (free tier)
        instance_type = "t2.micro"
        subnet_id = "subnet-5c078810"
        vpc_security_group_ids = ["sg-1d736579"]
	    count = 2
	    user_data = file("files/manager.sh")
	    tags = {
		    Name = "Manager ${count.index}"
	    }
        depends_on = [aws_instance.lider]
    	key_name = "ALD"
}



#Creacion de los Workers

resource "aws_instance" "Worker" {
        ami     = "ami-0bbe28eb2173f6167" # ubuntu AMI (free tier)
        instance_type = "t2.micro"
        subnet_id = "subnet-5c078810"
        vpc_security_group_ids = ["sg-0132732eca2883b9b"]
        count = 4
        user_data = file("files/workers.sh")
	    tags = {
                Name = "Worker ${count.index}"
        }
        depends_on = [aws_instance.lider]
    	key_name = "ALD"
}

output "lider_ip" {
  value       = aws_instance.lider.public_ip
  description = "Lider's Public IP"
  sensitive   = false
}


