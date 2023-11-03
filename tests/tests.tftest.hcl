### Provider configuration
provider "aws" {
  region  = "us-west-2"
  profile = "wa_demo"
}

# variables
# variables {
#     environment = "production"
# }

# setup
run "generate_tests_input_variables" {
    module {
        source = "./tests/setup"
    }
}

run "setup_dependancy" {
    module {
        source = "terraform-aws-modules/dynamodb-table/aws"
        version = "4.0.0"
    }
    variables {
        name          = "${run.generate_tests_input_variables.project_name}"
        hash_key = "id"
        attributes = [
          {
            name = "id"
            type = "N"
          }
        ]
    }
}

# tests
run "create_test_instance" {
    command = apply

    variables {
        environment = "${run.generate_tests_input_variables.environment_name}"
        project = "${run.generate_tests_input_variables.project_name}"
    }

    module {
        source = "./"
    }
}

run "check_instance_name" {
    command = plan

    variables {
        environment = "${run.generate_tests_input_variables.environment_name}"
        project = "${run.generate_tests_input_variables.project_name}"
    }

    assert {
        condition     = strcontains(run.create_test_instance.instance_name["Name"], "${var.project}-${run.generate_tests_input_variables.environment_type}-instance")
        error_message = "Wrong instance Name"
    }

    # expect_failures = [
    #     check.public_ip_assign
    # ]
}

run "check_instance_enviroment_type" {
    command = plan

    variables {
        environment = "${run.generate_tests_input_variables.environment_name}"
        project = "${run.generate_tests_input_variables.project_name}"
    }

    assert {
        condition     = strcontains(run.create_test_instance.instance_name["Type"], "prod")
        error_message = "Wrong instance Enviroment Type tag"
    }
    expect_failures = [
        check.public_ip_assign
    ]
}

run "check_instance_public_ip" {
    command = plan

    variables {
        environment = "${run.generate_tests_input_variables.environment_name}"
        project = "${run.generate_tests_input_variables.project_name}"
    }

    assert {
        condition     = run.create_test_instance.instance_public_ip != null
        error_message = "Check public ip"
    }
    expect_failures = [
        check.public_ip_assign
    ]
}