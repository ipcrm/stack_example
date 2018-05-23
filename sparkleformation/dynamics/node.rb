SparkleFormation.dynamic(:node) do |name, opts={}|

  parameters do
    set!("#{name}_flavor".to_sym) do
      type 'String'
      default 't2.small'
      allowed_values registry!(:instance_flavor)
    end
  end

  outputs.set!("#{name}_public_address".to_sym) do
    description "Compute instance public address - #{name}"
    value attr!("#{name}_ec2_instance".to_sym, :public_ip)
  end

  dynamic!(:ec2_instance, name) do
    properties do
      image_id ref!(:image_id_name)
      key_name ref!(:ssh_key_name)
      security_group_ids [ ref!(:global_ec2_security_group) ]
      instance_type ref!("#{name}_flavor".to_sym)
      subnet_id ref!(:network_subnet_id1)
    end
  end

end

