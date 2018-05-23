SparkleFormation.dynamic(:rds) do |name, opts={}|

  dynamic!(:r_d_s_d_b_subnet_group, name) do
    properties do
      d_b_subnet_group_description name
      d_b_subnet_group_name name
      subnet_ids [ ref!(:network_subnet_id1), ref!(:network_subnet_id2) ]
    end
  end

  dynamic!(:r_d_s_d_b_instance, name) do
    properties do
      engine 'MySQL'
      engine_version '5.6'
      allocated_storage '100'
      storage_type 'io1'
      iops 1000
      master_username ref!(:app_username)
      master_user_password ref!(:app_password)
      multi_a_z false
      d_b_instance_class 'db.m1.small'
      v_p_c_security_groups [ ref!(:global_ec2_security_group) ]
      d_b_subnet_group_name name
    end
  end

  outputs.set!("#{name}_endpoint_address".to_sym) do
    description "RDS Endpoint Address - #{name}"
    value attr!("#{name}_r_d_s_d_b_instance".to_sym, "Endpoint.Address".to_sym)
  end
end

