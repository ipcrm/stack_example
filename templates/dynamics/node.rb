SparkleFormation.dynamic(:node) do |name, opts={}|

  dynamic!(:ec2_instance, name) do
    properties do
      image_id ref!(:image_id_name)
      key_name ref!(:ssh_key_name)
      instance_type ref!(:flavor_type)
      user_data user_data_file!(opts[:userdata], iname: state!(:instance_name) ) if opts[:userdata]
      network_interfaces array!(
        -> {
         associate_public_ip_address true
         device_index 0
         subnet_id ref!(:network_subnet_id1)
         group_set [ ref!("#{state!(:instance_name)}_sg_ec2_security_group".to_sym) ]
        }
      )
    end
  end
end

