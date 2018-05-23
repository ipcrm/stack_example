SparkleFormation.new(:computedyn, :provider => :aws).load(:base).overrides do

  parameters do
    network_vpc_id.type 'String'
    network_subnet_id1.type 'String'
    network_subnet_id2.type 'String'

    ssh_key_name do
      type 'String'
      default 'sparkle'
    end

    image_id_name do
      type 'String'
      default 'ami-63ac5803'
    end
    app_username do
      type 'String'
      default 'computedyn'
    end
    app_password do
      type 'String'
      default 'computedyn'
    end
  end

  dynamic!(:ec2_security_group, :global) do
    properties do
      group_description 'Default Access'
      group_name 'default-global-group'
      security_group_ingress do
        cidr_ip '0.0.0.0/0'
        from_port 22
        to_port 22
        ip_protocol 'tcp'
      end
      vpc_id ref!(:network_vpc_id)
    end
  end

  dynamic!(:rds, :unicorn,
     :app_username => ref!(:app_username),
     :app_password => ref!(:app_password),
  )

  [:sparkle, :magic, :jawn].each do |x|
    dynamic!(:node, x)
  end
end
