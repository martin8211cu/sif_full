<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(102, url.ID)>

<!--- Parámetros Requeridos --->
<cfparam name="url.ID" type="numeric">
<cfparam name="url.MODO" type="string">

<cftransaction>

	<cfset LobjInterfaz.sbReportarActividad(111, url.ID)>

<!---	<cfthrow message="#url.ECIid#"> --->


	//Insertar los Campos restantes en la tabla ControlInterfaz18
	<cfquery datasource="sifinterfaces">
	Update ControlInterfaz18
	set Eperiodo   = a.PeriodoAsiento,
	    Emes       = a.MesAsiento,
	    Cconcepto  = a.Concepto,
	    Edocumento = a.Edocumento,
	    
	    Debitos    = isnull((Select sum(Dlocal)
				from iceweb6..DContables c
				where c.IDcontable = a.IDcontable
				  and c.Dmovimiento  = 'D'), 0),
	    
	    Creditos   = isnull((Select sum(Dlocal)
				from iceweb6..DContables c
				where c.IDcontable = a.IDcontable
				  and c.Dmovimiento  = 'C'), 0),

	    NumLineas  = isnull((Select count(1)
				from iceweb6..DContables c
				where c.IDcontable = a.IDcontable), 0),

	    Usuario    = Usulogin,
	    FechaApl   = a.FechaApl

	from iceweb6..EContablesInterfaz18 a 
		left join iceweb6..Usuario h
		    on a.UsrAplico = h.Usucodigo

	where a.ID = ControlInterfaz18.ID
	  and a.ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ECIid#"> 	

	</cfquery>

	<cfquery datasource="sifinterfaces">
	INSERT OE111(ID,ECIid)
	values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">,
	       <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ECIid#">)
	</cfquery>

	<cfset LobjInterfaz.sbReportarActividad(111, url.ID)>
</cftransaction>
