#!/bin/bash

# declare variables for template file, parameters file and stack name
template_file="template.json"
parameters_file="params.json"
stack_name="portfolio-static-website"

# perform operation specified in first command-line argument
case $1 in

    validate)
        # check if template file exists
        if ! test -f $template_file
        then
            echo "Provide a ${template_file} file to continue"
            exit 1
        fi

        # check if parameters file exists
        if ! test -f $parameters_file
        then
            echo "Provide a ${parameters_file} file"
            exit 1
        fi

        echo "VALIDATING STACK"
        aws cloudformation validate-template --template-body file://$template_file
        ;;

    create | update)
        # create or update aws resources
        echo "DEPLOYING STACK"
        aws cloudformation --profile leverage $1-stack --stack-name $stack_name --template-body file://$template_file --parameters file://$parameters_file
        ;;

    delete)
        # remove aws resources
        echo "DELETING STACK"
        aws cloudformation --profile leverage delete-stack --stack-name $stack_name
        ;;

    *)
        # fail if no valid operation has been specified
        echo "Provide a stack operation as either create, update or delete"
        exit 1
        ;;
esac