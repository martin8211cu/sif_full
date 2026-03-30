<cfquery datasource="#Gvar.Conexion#">
	insert into RHTPuestos (Ecodigo, RHTPcodigo, RHTPdescripcion, RHTinfo,BMusuario,BMfecha)
	select 	#Gvar.Ecodigo#, 
			#Gvar.table_name#.CDRHHTPcodigo,
			#Gvar.table_name#.CDRHHTPdescripcion,
			#Gvar.table_name#.CDRHHTPinfo,
			0,
			#now()#	
    from  #Gvar.table_name#
	where  CDPcontrolv = 1
	and coalesce(CDPcontrolg,0) = 0	
	and Ecodigo=#Gvar.table_name#.Ecodigo
</cfquery>
