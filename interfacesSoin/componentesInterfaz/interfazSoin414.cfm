<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />
<cfset LvarEcodigo = #datosXML.row.Ecodigo.xmltext#>
<cfset LvarDEidentificacion = #datosXML.row.Cedula.xmltext#>

<cfif  len(trim(#LvarEcodigo#)) eq 0  and  len(trim(#LvarDEidentificacion#)) eq 0>
	<cfthrow message="Se debe ingresar el código de la empresa ó la identificación de la persona ">
</cfif>

 <cfquery name="consulta" datasource="#session.DSN#">
 
		select  DatosEmpl.Ecodigo,DatosEmpl.DEidentificacion, DatosEmpl.DEid,DatosEmpl.DEnombre, DatosEmpl.DEapellido1, DatosEmpl.DEapellido2,
				CFunc.CFcodigo, CFunc.CFdescripcion,				
				coalesce(LT.LTsalario,0) as LTsalario
				
		from DatosEmpleado DatosEmpl,  				
		 LineaTiempo LT
			  			  						  
		 inner join  RHPlazas PLZ
		  on LT.RHPid = PLZ.RHPid  
		  and LT.Ecodigo = PLZ.Ecodigo
									
		  inner join CFuncional CFunc
		   on PLZ.CFid = CFunc.CFid
		   and PLZ.Ecodigo =  CFunc.Ecodigo    
						
		 inner join  DLineaTiempo Dlinea
			on Dlinea.LTid = LT.LTid 
		
		 inner join  ComponentesSalariales c
		   on  Dlinea.CSid = c.CSid
		   and CSsalariobase = 1
		   		 		   
	 where  LT.DEid =  DatosEmpl.DEid
	 	and LT.Ecodigo = DatosEmpl.Ecodigo	  
	 	and getdate() between LT.LTdesde and LT.LThasta
	 <cfif len(trim(LvarEcodigo)) and trim(LvarEcodigo) NEQ -1 >
	 	and DatosEmpl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">
	 </cfif>
	 <cfif len(trim(LvarDEidentificacion)) and trim(LvarDEidentificacion) NEQ -1> 
	 	and DatosEmpl.DEidentificacion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDEidentificacion#">
	 </cfif>
	 	  
</cfquery> 

<cfset count = 0>
<cfif consulta.RecordCount gt 0>
<cfset LvarSalida = "<resulset>">

<cfloop query="consulta" >
 <cfquery name="rsSalenRecarg" datasource="#session.DSN#">
	select coalesce(LTR.LTsalario, 0) as salarioRec 
	from LineaTiempoR LTR
	where  LTR.DEid = #consulta.DEid#
	 <cfif len(trim(LvarEcodigo)) and trim(LvarEcodigo) NEQ -1 >	
		and LTR.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">
	 </cfif>	
	and getdate() between LTR.LTdesde and LTR.LThasta 
  </cfquery>


<cfif rsSalenRecarg.RecordCount gt 0>
	<cfset salarioTotal = #consulta.LTsalario# + #rsSalenRecarg.salarioRec# >
<cfelse>
	<cfset salarioTotal = #consulta.LTsalario#>
</cfif>

<cfset count = count + 1 >
<cfset LvarSalida &= " <row>
							<Ecodigo>#consulta.Ecodigo#</Ecodigo>
							<DEidentificacion>#consulta.DEidentificacion#</DEidentificacion>
							<Nombre>#consulta.DEnombre#</Nombre>
							<Apellido1>#consulta.DEapellido1#</Apellido1>
							<Apellido2>#consulta.DEapellido2#</Apellido2>
							<CFcodigo>#consulta.CFcodigo# </CFcodigo>
							<CFdescripcion>#consulta.CFdescripcion# </CFdescripcion>
							<salario>#salarioTotal#</salario>		
						 </row>">		  
	 
 </cfloop>
<cfset LvarSalida &= 
"</resulset>" >
<cfset GvarXML_OE = LvarSalida>


</cfif>




