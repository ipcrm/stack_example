SparkleFormation.dynamic(:node) do |name, opts={}|

  parameters do
    set!("#{name}_flavor".to_sym) do
      type 'String'
      default 't2.small'
      allowed_values registry!(:instance_flavor)
    end
  end

  dynamic!(:ec2_instance, name) do
    properties do
      image_id ref!(:image_id_name)
      key_name ref!(:ssh_key_name)
      instance_type ref!("#{name}_flavor".to_sym)
      network_interfaces array!(
        -> {
         associate_public_ip_address true
         device_index 0
         subnet_id ref!(:network_subnet_id1)
         group_set [ ref!(:global_ec2_security_group) ]
        }
      )
    end
  end

end

