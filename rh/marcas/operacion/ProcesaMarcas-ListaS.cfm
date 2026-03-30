<!--- para asegurarnos de no dejar basura en la temporal se borrara registros  con un dia de antiguedad o los generado por la session, --->
<!--- Elimina todos los registro mayores a un día de generación para el usuario en session---> 
<cfset fecha = DateAdd("d", -1, now())>

<cfquery name="rsinsert" datasource="#Session.DSN#">
	delete  TMP_MarcasSemanal
	where
	usuario  = #session.usucodigo#
	and	generado < <cfqueryparam value="#fecha#" cfsqltype="cf_sql_timestamp">
</cfquery> 

<cfquery name="rsmax" datasource="#Session.DSN#">
	select coalesce(max(consecutivo),0) + 1 as consecutivo from TMP_MarcasSemanal
	where
	usuario  = #session.usucodigo#
</cfquery>
<cfif rsmax.recordCount eq 0>
	<cfset rsmax.consecutivo = 0 >
</cfif>



<cfquery name="RS_fechaInicio" datasource="#session.DSN#">
	Select  Min(CAMfdesde) as FechaIni , Max(CAMfdesde) as FechaFin
	from RHCMCalculoAcumMarcas
	Where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and CAMestado='P'
</cfquery>	

<cfif len(trim(form.fechaInicio))EQ 0>
	<cfset form.fechaInicio = LSDateFormat(RS_fechaInicio.FechaIni, "dd/mm/yyyy")> 
</cfif>
<cfif len(trim(form.fechaFinal))EQ 0>
	<cfset form.fechaFinal  = LSDateFormat(RS_fechaInicio.FechaFin, "dd/mm/yyyy")>
</cfif>
<!--- 
	busca cual es el primer día de la semana para el sistema 
	ya que con este forma las agrupaciones en caso de no estar 
	definido toma el lunes como primer dia
 --->
<cfquery name="RS_DiaSemana" datasource="#session.DSN#">
	Select PrimerDiaSemana = Pvalor
	From RHParametros 
	Where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo=780												
</cfquery>
<cfif RS_DiaSemana.recordCount GT 0>
	<cfif len(trim(RS_DiaSemana.PrimerDiaSemana)) EQ 0>
		<cfset Lvar_PrimerDiaSemana = 2>
	<cfelseif RS_DiaSemana.PrimerDiaSemana eq 7>
		<cfset Lvar_PrimerDiaSemana = 1>
	<cfelse>
		<cfset Lvar_PrimerDiaSemana = RS_DiaSemana.PrimerDiaSemana +1>
	</cfif>	
<cfelse>
	<cfset Lvar_PrimerDiaSemana = 2>
</cfif>


<!--- <cfset Lvar_PrimerDiaSemana = 4> --->
<!--- ******************************************************* --->
<cfif DatePart('d',form.fechaInicio) gt 12>
	<cfset Day_ini = DatePart('d',form.fechaInicio)>
	<cfset Month_ini = DatePart('m',form.fechaInicio)>
<cfelse>
	<cfset Day_ini = DatePart('m',form.fechaInicio)>
	<cfset Month_ini = DatePart('d',form.fechaInicio)>
</cfif> 
<cfset year_ini = DatePart('yyyy',form.fechaInicio)>

<cfif DatePart('d',form.fechaFinal) gt 12>
	<cfset Day_fin = DatePart('d',form.fechaFinal)>
	<cfset Month_fin = DatePart('m',form.fechaFinal)>
<cfelse>
	<cfset Day_fin = DatePart('m',form.fechaFinal)>
	<cfset Month_fin = DatePart('d',form.fechaFinal)>
</cfif> 
<cfset year_fin = DatePart('yyyy',form.fechaFinal)>

<!--- Pre formate o de fechas e incializacion de variables --->
<cfset fechaInicio = CreateDate(year_ini, Month_ini,Day_ini)>
<cfset fechaFinal = CreateDate(year_fin, Month_fin,Day_fin)>

<cfset fechainicioSemana = fechaInicio>
<cfset fechafinSemana = fechaInicio>
<cfset contadorsemana = 1>
<!--- 
	la logica de agrupamiento es la siguiente
		si el dia de la semana de la fecha inicio es menos a la definida en el sistema
		se retrocede la fecha de inicio hasta completar la semana.
 --->
<cfif DayOfWeek(fechaInicio) gt Lvar_PrimerDiaSemana>
	<cfset contadorsemana = contadorsemana + (DayOfWeek(fechaInicio) - Lvar_PrimerDiaSemana)>
<cfelseif DayOfWeek(fechaInicio) lt  Lvar_PrimerDiaSemana>
	 <cfloop index = "d" from = "1" to = "6">
		<cfif DayOfWeek(fechaInicio) EQ Lvar_PrimerDiaSemana>
			<cfbreak>
		</cfif>
		<cfset fechaInicio =  DateAdd('d',-1,fechaInicio)>
	</cfloop>
</cfif>
<cfoutput>
<!--- 
	Una vez definido el incio y el fin de las fechas de busquedas se procede
	a insertar los registros agrupados semanalmente.
 --->
<cfloop 
	from = "#fechaInicio#"
	to = "#fechaFinal#"
	index = "i"> 
	<cfset fechafinSemana = i>
	<cfif contadorsemana eq 7>
		<cfquery name="rsinsert" datasource="#Session.DSN#">
			Insert into TMP_MarcasSemanal(consecutivo,usuario,DEid, FechaDesde,FechaHasta,generado, HT)
			Select distinct
				#rsmax.consecutivo#	,
				#session.usucodigo#,
				DEid,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechainicioSemana#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechafinSemana#">,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				 0
			From RHCMCalculoAcumMarcas a
			Where CAMestado='P'
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>
			<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
				and  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#"> in (Select Gid from RHCMEmpleadosGrupo b Where a.DEid=b.DEid)
			</cfif>
			and <cf_dbfunction name="to_sdate" args="a.CAMfdesde">  between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechainicioSemana#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechafinSemana#">
		</cfquery>
		<cfset contadorsemana = 1>
		<cfset fechainicioSemana =  DateAdd('d',1,fechafinSemana)>
	<cfelse>
		<cfset contadorsemana = contadorsemana + 1>
	</cfif>
</cfloop>
<cfif contadorsemana neq 1 and fechainicioSemana lte fechaFinal>
	<cfquery name="rsinsert" datasource="#Session.DSN#">
		Insert into TMP_MarcasSemanal(consecutivo,usuario,DEid, FechaDesde,FechaHasta,generado, HT)
		Select distinct
				#rsmax.consecutivo#,	
				#session.usucodigo#,
			 DEid,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechainicioSemana#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaFinal#">,
			<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
			
			 0
		From RHCMCalculoAcumMarcas a
		Where CAMestado='P'
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif>
		<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
			and  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#"> in (Select Gid from RHCMEmpleadosGrupo b Where a.DEid=b.DEid)
		</cfif>
		and <cf_dbfunction name="to_sdate" args="a.CAMfdesde"> between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechainicioSemana#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaFinal#">
	</cfquery>
</cfif>
<!--- ************************************************************************************* --->
<!---  Cuando se han Creado cada uno de las Semanas/Empleado se actualizan los acumulados existentes en cada semana--->
<!---  Se aplica un <cf_dbfunction name="to_sdate" args="b.CAMfdesde"> porque las Fechas almacenadas tienen Hora y Minutos--->
<!--- *************************************************************************************--->

<cfquery name="rsupdate" datasource="#Session.DSN#">
	update TMP_MarcasSemanal
	set HT = (Select sum(CAMtotminutos)/60.00
			  from RHCMCalculoAcumMarcas b
			  Where TMP_MarcasSemanal.DEid=b.DEid
			  and b.CAMestado='P'
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and <cf_dbfunction name="to_sdate" args="b.CAMfdesde"> between TMP_MarcasSemanal.FechaDesde and TMP_MarcasSemanal.FechaHasta),
	 	HO = (Select sum(CAMociominutos)/60.00
			  from RHCMCalculoAcumMarcas b
			  Where TMP_MarcasSemanal.DEid=b.DEid
			  and b.CAMestado='P'
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and <cf_dbfunction name="to_sdate" args="b.CAMfdesde"> between TMP_MarcasSemanal.FechaDesde and TMP_MarcasSemanal.FechaHasta),
	 	HL = (Select sum(CAMtotminlab)/60.00
			  from RHCMCalculoAcumMarcas b
			  Where TMP_MarcasSemanal.DEid=b.DEid
			  and b.CAMestado='P'
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and <cf_dbfunction name="to_sdate" args="b.CAMfdesde"> between TMP_MarcasSemanal.FechaDesde and TMP_MarcasSemanal.FechaHasta),
	 	HR = (Select sum(CAMcanthorasreb)/60.00
			  from RHCMCalculoAcumMarcas b
			  Where TMP_MarcasSemanal.DEid=b.DEid
			  and b.CAMestado='P'
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and <cf_dbfunction name="to_sdate" args="b.CAMfdesde"> between TMP_MarcasSemanal.FechaDesde and TMP_MarcasSemanal.FechaHasta),
	 	HN = (Select sum(CAMcanthorasjornada)
			  from RHCMCalculoAcumMarcas b
			  Where TMP_MarcasSemanal.DEid=b.DEid
			  and b.CAMestado='P'
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and <cf_dbfunction name="to_sdate" args="b.CAMfdesde"> between TMP_MarcasSemanal.FechaDesde and TMP_MarcasSemanal.FechaHasta),
		HEA = (Select coalesce(sum(CAMcanthorasextA),0)
			  from RHCMCalculoAcumMarcas b
			  Where TMP_MarcasSemanal.DEid=b.DEid
			  and b.CAMestado='P'
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and <cf_dbfunction name="to_sdate" args="b.CAMfdesde"> between TMP_MarcasSemanal.FechaDesde and TMP_MarcasSemanal.FechaHasta),
		HEB = (Select sum(coalesce(CAMcanthorasextB,0))
			  from RHCMCalculoAcumMarcas b
			  Where TMP_MarcasSemanal.DEid=b.DEid
			  and b.CAMestado='P'
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and <cf_dbfunction name="to_sdate" args="b.CAMfdesde"> between TMP_MarcasSemanal.FechaDesde and TMP_MarcasSemanal.FechaHasta),
		MontoFeriado = (Select sum(CAMmontoferiado)
			  from RHCMCalculoAcumMarcas b
			  Where TMP_MarcasSemanal.DEid=b.DEid
			  and b.CAMestado='P'
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and <cf_dbfunction name="to_sdate" args="b.CAMfdesde"> between TMP_MarcasSemanal.FechaDesde and TMP_MarcasSemanal.FechaHasta)
	Where exists (Select 1
				from RHCMCalculoAcumMarcas b
			  	Where TMP_MarcasSemanal.DEid=b.DEid
			  	and b.CAMestado='P'
			    and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  	and <cf_dbfunction name="to_sdate" args="b.CAMfdesde"> between TMP_MarcasSemanal.FechaDesde and TMP_MarcasSemanal.FechaHasta)
	  and TMP_MarcasSemanal.usuario = #session.usucodigo#
	  and TMP_MarcasSemanal.consecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsmax.consecutivo#">	
</cfquery>
<cfquery name="rsinsert" datasource="#Session.DSN#">
	delete from TMP_MarcasSemanal
	Where HT=0 
	and   MontoFeriado = 0
	and TMP_MarcasSemanal.usuario = #session.usucodigo#
	and TMP_MarcasSemanal.consecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsmax.consecutivo#">	
</cfquery>
<!---   *************************************************************************************--->
<!---   Almaceno la Cantidad de Jornadas que hay por Semana, donde durante la Semana Existe más de una Jornada utilizada --->
<!---  ************************************************************************************* --->
<cfquery name="rsinsert" datasource="#Session.DSN#">
	update TMP_MarcasSemanal
	set CantJornadas=coalesce((Select count(distinct RHJid)
			 from RHCMCalculoAcumMarcas b
			 Where 	<cf_dbfunction name="to_sdate" args="b.CAMfdesde"> >= TMP_MarcasSemanal.FechaDesde 
					and  <cf_dbfunction name="to_sdate" args="b.CAMfdesde"> <= TMP_MarcasSemanal.FechaHasta
			 and   TMP_MarcasSemanal.DEid=b.DEid
			 and b.CAMestado='P'
			and TMP_MarcasSemanal.usuario = #session.usucodigo#
			and TMP_MarcasSemanal.consecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsmax.consecutivo#">	
			 group by b.DEid),0)
	where 	 TMP_MarcasSemanal.usuario = #session.usucodigo#
			and TMP_MarcasSemanal.consecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsmax.consecutivo#">	
</cfquery>
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td>
		<iframe  
			id="MOD_AUTO" 
			name="MOD_AUTO" 
			marginheight="0" 
			marginwidth="0" 
			frameborder="0" 
			height="450px" 
			width="100%"  style="border:none"  scrolling="no" 
			src="Form-ProcesaMarcas-ListaS.cfm?consecutivo=#rsmax.consecutivo#">
		</iframe>
	</td>
  </tr>
    <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><img src=/cfmx/rh/imagenes/checked.gif>&nbsp;<font style="color:##0000FF"><cf_translate  key="LB_Mensaje">Indica que el empleado tiene combinaci&oacute;n de jornadas en esa semana </cf_translate></font></td>
  </tr>
</table>



</cfoutput>
