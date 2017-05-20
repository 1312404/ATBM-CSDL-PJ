-- All of Employees (without Department chief, Branch manager, Project manager)
-- Only them can view thier informations and others in thier department, and viewing thier salaries

-- Create VPD Policy Function 
create or replace function viewInformAndSalary(p_schema varchar2, p_obj varchar2) 
  return varchar2 
  as 
    UserID varchar2(200);
  begin  
    UserID := SYS_CONTEXT('USERENV','SESSION_USER');
    if(UserID like 'nv%') then
      return 
        'Employee.EmployeeID in (select EmployeeID from Atbmhttt_Lab01.Employee where EmployeeID = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''' || ')'; 
    else
      return '';
  end;
  
-- Assigning Policy function to view InformAndSalary
begin
dbms_rls.add_policy 
(
  object_schema     => 'Atbmhttt_Lab01', 
  object_name       => 'Employee', 
  policy_name       => 'viewInformAndSalaryVPD', 
  function_schema   => 'Atbmhttt_Lab01', 
  policy_function   => 'viewInformAndSalary', 
  statement_types   => 'select, update, insert, delete', 
  sec_relevant_cols => 'Salary',
  update_check      => TRUE
);
end;

begin
dbms_rls.drop_policy
(
  object_schema => 'Atbmhttt_Lab01', 
  object_name   => 'Employee', 
  policy_name   => 'viewInformAndSalaryVPD'
);
end;

