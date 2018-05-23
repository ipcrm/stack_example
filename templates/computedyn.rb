SparkleFormation.new(:computedyn,
  :compile_time_parameters => {
    :frontend_count => { :type => :number, :default => 1 },
    :instance_name  => { :type => :string },
  },
  :provider => :aws
).load(:base).overrides do
parameters do
    network_vpc_id.type 'String'
    network_subnet_id1.type 'String'
    network_subnet_id2.type 'String'
    instance_name.type 'String'
    flavor_type.type 'String'
    frontend_count.type 'Number'

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

  dynamic!(:ec2_security_group, "#{state!(:instance_name)}_sg".to_sym) do
    properties do
      group_description "#{state!(:instance_name)}_sg"
      group_name "#{state!(:instance_name)}_sg"
      vpc_id ref!(:network_vpc_id)
    end
  end

  dynamic!(:ec2_security_group_ingress, "#{state!(:instance_name)}_udp_ingress".to_sym) do
    properties do
      group_id ref!("#{state!(:instance_name)}_sg_ec2_security_group".to_sym)
      cidr_ip '0.0.0.0/0'
      from_port 0
      to_port 65535
      ip_protocol 'udp'
    end
  end

  dynamic!(:ec2_security_group_ingress, "#{state!(:instance_name)}_ec2_security_group".to_sym) do
    properties do
      group_id ref!("#{state!(:instance_name)}_sg_ec2_security_group".to_sym)
      group_name
      cidr_ip '0.0.0.0/0'
      from_port 0
      to_port 65535
      ip_protocol 'tcp'
    end
  end

  dynamic!(:rds, state!(:instance_name),
     :app_username => ref!(:app_username),
     :app_password => ref!(:app_password),
  )

  state!(:frontend_count).to_i.times do |i|
    dynamic!(:node, "#{state!(:instance_name)}#{i}")
  end
end
