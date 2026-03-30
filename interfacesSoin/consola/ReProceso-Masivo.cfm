	<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">

<!--- Creado por Gabriel Ernesto Sanchez Huerta  para  AppHost  14/09/2010 --->

<!--- <cf_dump var="#Form#"> --->

<cfif isdefined("form.btnReprocesar")>
<cfset ids = ArrayNew(1)>
	<cfif isdefined("form.chk")>
		<cfset ids = ListToArray(form.chk)>        
		<cfloop from="1" to="#ArrayLen(ids)#" index="id">
        
			<cfset pipe = Find("|",#ids[id]#)>
            <cfset pipe2 = Find("|",#ids[id]#,#pipe#+1)>
            <cfset pipe3 = Find("|",#ids[id]#,#pipe2#+1)>

			<cfset Status = Mid(#ids[id]#,1,#pipe#-1)>
            <cfset IdProceso = mid(#ids[id]#,#pipe#+1,#pipe2#-(#pipe#+1))>
            <cfset Interfaz = mid(#ids[id]#,#pipe2#+1,#pipe3#-(#pipe2#+1))>
            <cfset SecReproceso = Mid(#ids[id]#,#pipe3#+1,4)>
           
			<cfquery name="rsSQL" datasource="sifinterfaces">
				select StatusProceso as status
				  from InterfazColaProcesos
				 where CEcodigo 		= #session.CEcodigo#
				   and NumeroInterfaz 	= #Interfaz#
				   and IdProceso		= #IdProceso# 
				   and SecReproceso		= #SecReproceso#
			</cfquery>
            <cfif rsSQL.Status EQ 3>
				<cfset LobjColaProcesos.fnProcesoReprocesar (#Interfaz#,#IdProceso#,#SecReproceso#,"MASIVO")> 
			<cfelseif rsSQL.Status EQ 5>
				<cfset LobjColaProcesos.fnProcesoReprocesarSpFinal (#session.CEcodigo#, #Interfaz#,#IdProceso#,#SecReproceso#)> 
			</cfif>
		</cfloop>
		<!---<cfif ArrayLen(ids) GT 0>
			<cfset LobjColaProcesos.fnProcesoReprocesar (#Interfaz#,#IdProceso#,#SecReproceso#,"MASIVO_FINAL")> 
		</cfif>--->
	</cfif>	
</cfif>

<cfoutput>
<HTML>
<head>
</head>
<body>
<form action="consola-procesos.cfm" method="post" name="sql">
	<cfif isdefined("Form.fltStatus") and Len(Trim(Form.fltStatus))>
		<input type="hidden" name="fltStatus" value="#Form.fltStatus#">
	</cfif>
	<cfif isdefined("Form.fltFechaDesde") and Len(Trim(Form.fltFechaDesde))>
		<input type="hidden" name="fltFechaDesde" value="#Form.fltFechaDesde#">
	</cfif>
	<cfif isdefined("Form.fltFechaHasta") and Len(Trim(Form.fltFechaHasta))>
		<input type="hidden" name="fltFechaHasta" value="#Form.fltFechaHasta#">
	</cfif>
	<cfif isdefined("Form.fltInterfaz") and Len(Trim(Form.fltInterfaz))>
		<input type="hidden" name="fltInterfaz" value="#Form.fltInterfaz#">
	</cfif>
	<cfif isdefined("Form.fltOrigen") and Len(Trim(Form.fltOrigen))>
		<input type="hidden" name="fltOrigen" value="#Form.fltOrigen#">
	</cfif>
	<cfif isdefined("Form.chkRefrescar") and Len(Trim(Form.chkRefrescar))>
		<input type="hidden" name="chkRefrescar" value="#Form.chkRefrescar#">
	</cfif>
	<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
		<input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#">
	</cfif>
</form>
</cfoutput>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>