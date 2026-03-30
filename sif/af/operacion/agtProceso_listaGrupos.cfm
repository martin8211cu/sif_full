<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<cfparam name="form.Pagina" default="1">
<!--- FILTROS --->
<cfif isdefined('url.Filtro_AGTPdescripcion') and not isdefined('form.Filtro_AGTPdescripcion')>
	<cfset form.Filtro_AGTPdescripcion = url.Filtro_AGTPdescripcion>
</cfif>
<cfif isdefined('url.Filtro_AGTPestadoDesc') and not isdefined('form.Filtro_AGTPestadoDesc')>
	<cfset form.Filtro_AGTPestadoDesc = url.Filtro_AGTPestadoDesc>
</cfif>
<cfif isdefined('url.Filtro_AGTPfalta') and not isdefined('form.Filtro_AGTPfalta')>
	<cfset form.Filtro_AGTPfalta = url.Filtro_AGTPfalta>
</cfif>
<cfif isdefined('url.Filtro_AGTPmesDesc') and not isdefined('form.Filtro_AGTPmesDesc')>
	<cfset form.Filtro_AGTPmesDesc = url.Filtro_AGTPmesDesc>
</cfif>
<cfif isdefined('url.Filtro_AGTPperiodo') and not isdefined('form.Filtro_AGTPperiodo')>
	<cfset form.Filtro_AGTPperiodo = url.Filtro_AGTPperiodo>
</cfif>

<cfif isdefined('url.HFiltro_AGTPdescripcion') and not isdefined('form.Filtro_AGTPdescripcion')>
	<cfset form.HFiltro_AGTPdescripcion = url.HFiltro_AGTPdescripcion>
</cfif>
<cfif isdefined('url.HFiltro_AGTPestadoDesc') and not isdefined('form.Filtro_AGTPestadoDesc')>
	<cfset form.HFiltro_AGTPestadoDesc = url.HFiltro_AGTPestadoDesc>
</cfif>
<cfif isdefined('url.HFiltro_AGTPfalta') and not isdefined('form.Filtro_AGTPfalta')>
	<cfset form.HFiltro_AGTPfalta = url.HFiltro_AGTPfalta>
</cfif>
<cfif isdefined('url.HFiltro_AGTPmesDesc') and not isdefined('form.Filtro_AGTPmesDesc')>
	<cfset form.HFiltro_AGTPmesDesc = url.HFiltro_AGTPmesDesc>
</cfif>
<cfif isdefined('url.HFiltro_AGTPperiodo') and not isdefined('form.Filtro_AGTPperiodo')>
	<cfset form.HFiltro_AGTPperiodo = url.HFiltro_AGTPperiodo>
</cfif>
<!--- FILTROS DE LA LISTA --->

<cfset params = ''>
<cfif isdefined('form.Filtro_AGTPdescripcion')>
	<cfset params = params & 'Filtro_AGTPdescripcion=#form.Filtro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPestadoDesc')>
	<cfset params = params & '&Filtro_AGTPestadoDesc=#form.Filtro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPfalta')>
	<cfset params = params & '&Filtro_AGTPfalta=#form.Filtro_AGTPfalta#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPmesDesc')>
	<cfset params = params & '&Filtro_AGTPmesDesc=#form.Filtro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPperiodo')>
	<cfset params = params & '&Filtro_AGTPperiodo=#form.Filtro_AGTPperiodo#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPdescripcion')>
	<cfset params = params & '&HFiltro_AGTPdescripcion=#form.HFiltro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPestadoDesc')>
	<cfset params = params & '&HFiltro_AGTPestadoDesc=#form.HFiltro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPfalta')>
	<cfset params = params & '&HFiltro_AGTPfalta=#form.HFiltro_AGTPfalta#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPmesDesc')>
	<cfset params = params & '&HFiltro_AGTPmesDesc=#form.HFiltro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPperiodo')>
	<cfset params = params & '&HFiltro_AGTPperiodo=#form.HFiltro_AGTPperiodo#'>
</cfif>

<!--- FILTROS --->


<!---IDtrans--->
<cfif isdefined("url.IDtrans") and not (isdefined("IDtrans") and len(trim(IDtrans)))><cfset IDtrans = url.IDtrans></cfif>
<cfif isdefined("form.IDtrans") and not (isdefined("IDtrans") and len(trim(IDtrans)))><cfset IDtrans = form.IDtrans></cfif>

<cfparam name="IDtrans" type="numeric">

<!---filtro--->
<cfif IDtrans NEQ 11>
	<cfset filtro = "a.Ecodigo=#session.Ecodigo# and a.IDtrans=#IDtrans# and a.AGTPecodigo > 0 and a.AGTPestadp <= 2 ">
<cfelse>
	<cfset filtro= "a.Ecodigo=#session.Ecodigo#">
</cfif>

<cfif IDtrans NEQ 11>
	<cfif isdefined('form.Filtro_AGTPestadoDesc') and len(trim(form.Filtro_AGTPestadoDesc)) and #form.Filtro_AGTPestadoDesc# neq -1>
        <cfset filtro = filtro & " and AGTPestadp=#form.Filtro_AGTPestadoDesc#">
    </cfif>
<cfelse>
	<cfif isdefined('form.Filtro_AGTPestadoDesc') and len(trim(form.Filtro_AGTPestadoDesc)) and #form.Filtro_AGTPestadoDesc# neq -1>
        <cfset filtro = filtro & " and TipoMovimiento=#form.Filtro_AGTPestadoDesc#">
    </cfif>
</cfif>

<cfif isdefined('form.Filtro_AGTPdescripcion') and len(trim(form.Filtro_AGTPdescripcion))>
		<cfset filtro = filtro & " and upper(AGTPdescripcion) like '%#Ucase(Form.Filtro_AGTPdescripcion)#%' ">
</cfif>


<cfif isdefined('form.Filtro_AGTPperiodo') and len(trim(form.Filtro_AGTPperiodo))>
	<cfset filtro = filtro & " and AGTPperiodo=#form.Filtro_AGTPperiodo#">
</cfif>

<cfif isdefined('form.Filtro_AGTPmesDesc') and len(trim(form.Filtro_AGTPmesDesc))>
	<cfset filtro = filtro & " and upper(VSdesc) like '%#Ucase(Form.Filtro_AGTPmesDesc)#%' ">
</cfif>



<!--- Estados (	0=en proceso,
				1=programado para generar
				2=programado para aplicar
				4=aplicado
				5=borrado por el usuario)
				--->
<!---navegacion--->
<cfset navegacion = "&IDtrans=#IDtrans#">
<!---curentPage obtiene la pagina actual porque este fuente puede estar incluido en varios archivos.--->
<cfset currentPage = GetFileFromPath(GetTemplatePath())>
<!---botonAccion define la descripcion y la accin del boton de acuerdo con el IDtrans recibido --->
<cfset botonAccion = ArrayNew(2)>

<cfset botonAccion[200050][1] = "">
<cfset botonAccion[200050][2] = "">
<cfset botonAccion[200050][3] = "">
<cfset botonAccion[200050][4] = "">
<cfset botonAccion[200050][5] = "">
<cfset botonAccion[200050][6] = "">
<cfset botonAccion[200050][7] = "">

<cfset botonAccion[4][1] = "Generar">
<cfset botonAccion[4][2] = "DEPRECIACION">
<cfset botonAccion[4][3] = "Lista de Grupos de Transacciones de Depreciaci&oacute;n">
<cfset botonAccion[4][4] = "">
<cfset botonAccion[4][5] = "programa">
<cfset botonAccion[4][6] = 0>
<cfset botonAccion[4][7] = "detalles">

<cfset botonAccion[3][1] = "Generar">
<cfset botonAccion[3][2] = "REVALUACION">
<cfset botonAccion[3][3] = "Lista de Grupos de Transacciones de Revaluaci&oacute;n">
<cfset botonAccion[3][4] = "">
<cfset botonAccion[3][5] = "programa">
<cfset botonAccion[3][6] = 0>
<cfset botonAccion[3][7] = "detalles">

<cfset botonAccion[5][1] = "Nuevo">
<cfset botonAccion[5][2] = "RETIRO">
<cfset botonAccion[5][3] = "Lista de Grupos de Transacciones de Retiro">
<cfset botonAccion[5][4] = "">
<cfset botonAccion[5][5] = "sql">
<cfset botonAccion[5][6] = 1>
<cfset botonAccion[5][7] = "genera">

<cfset botonAccion[8][1] = "Nuevo">
<cfset botonAccion[8][2] = "TRASLADO">
<cfset botonAccion[8][3] = "Lista de Grupos de Transacciones de Traslado">
<cfset botonAccion[8][4] = "">
<cfset botonAccion[8][5] = "sql">
<cfset botonAccion[8][6] = 1>
<cfset botonAccion[8][7] = "genera">

<cfset botonAccion[6][1] = "Nuevo">
<cfset botonAccion[6][2] = "CAMCATCLAS">
<cfset botonAccion[6][3] = "Lista de Grupos de Cambios de Categoria Clase">
<cfset botonAccion[6][4] = "">
<cfset botonAccion[6][5] = "sql">
<cfset botonAccion[6][6] = 1>
<cfset botonAccion[6][7] = "genera">

<cfset botonAccion[7][1] = "Nuevo">
<cfset botonAccion[7][2] = "CAMTIPO">
<cfset botonAccion[7][3] = "Lista de Grupos de Cambios de tipo">
<cfset botonAccion[7][4] = "">
<cfset botonAccion[7][5] = "sql">
<cfset botonAccion[7][6] = 1>
<cfset botonAccion[7][7] = "genera">

<cfset botonAccion[2][1] = "Nuevo">
<cfset botonAccion[2][2] = "MEJORA">
<cfset botonAccion[2][3] = "Lista de Grupos de Transacciones de Mejora">
<cfset botonAccion[2][4] = "">
<cfset botonAccion[2][5] = "sql">
<cfset botonAccion[2][6] = 1>
<cfset botonAccion[2][7] = "genera">

<cfset botonAccion[10][1] = "Nuevo">
<cfset botonAccion[10][2] = "CAMPLACA">
<cfset botonAccion[10][3] = "Lista de Grupos de Cambios de Placa">
<cfset botonAccion[10][4] = "">
<cfset botonAccion[10][5] = "sql">
<cfset botonAccion[10][6] = 1>
<cfset botonAccion[10][7] = "genera">

<cfset botonAccion[11][1] = "">
<cfset botonAccion[11][2] = "Salida">
<cfset botonAccion[11][3] = "Lista de Grupos de Transacciones de Salida de Activo">
<cfset botonAccion[11][4] = "">
<cfset botonAccion[11][5] = "sql">
<cfset botonAccion[11][6] = 1>
<cfset botonAccion[11][7] = "genera">


<!---Estados--->
<cfif (IDtrans EQ 7) or (IDtrans EQ 10)>
	<cfquery name="rsEstados" datasource="#session.DSN#">
		select  0 as value, 'En Proceso' as description from dual
	</cfquery>
<cfelseif (IDtrans EQ 11)>
	<cfquery name="rsEstados" datasource="#session.DSN#">
	    select  -1 as value, 'Todos' as description from dual
		union all
		select  1 as value, 'Entrada' as description from dual
        union all
		select 2 as value, 'Salida' as description from dual
		union all
		select 3 as value, 'Comodato' as description from dual
		union all
		select 4 as value, 'Comodato Devuelto' as description from dual
        order by 1
	</cfquery>
<cfelse>
	<cfquery name="rsEstados" datasource="#session.DSN#">
		select  -1 as value, 'Todos' as description from dual
		union all
		select  0 as value, 'En Proceso' as description from dual
		union all
		select 1 as value, 'Por Generar' as description from dual
		union all
		select 2 as value, 'Por Aplicar' as description from dual
		order by 1
	</cfquery>
</cfif>

<!---Elimiar se decidi hacer aqu porque para todos es igual--->
<cfif isdefined("form.btnEliminar") and isdefined("form.chk") and len(trim(Form.chk))>


	<cfset alertasisext = false>
	<cfloop index = "item"	list = "#Form.chk#"	delimiters = ",">

    <cfif IDtrans NEQ 11>
            <cfquery name="rsCheckToDelete" datasource="#session.dsn#">
                select AGTPexterno
                from AGTProceso
                where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
                and AGTPestadp < 4
            </cfquery>

			<cfif (rsCheckToDelete.RecordCount eq 1) and rsCheckToDelete.AGTPexterno eq 0>
                <cfquery name="rsDelete0" datasource="#session.dsn#">
                    select count(1) as Registros
                    from ADTProceso
                    where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
                        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
                </cfquery>

                <cfquery name="rsDelete1" datasource="#session.dsn#">
                    delete
                    from ADTProceso
                    where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
                        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
                </cfquery>

                <!--- Estado = 5 > Borrado --->
                <cfquery name="rsDelete2" datasource="#session.dsn#">
                    update AGTProceso
                    set AGTPestadp = 5,
                        AGTPfecborrado = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                        AGTPusuborrado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                        AGTPregborrado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDelete0.Registros#">
                    where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
                        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
                </cfquery>
            <cfelse>
			<cfif rsCheckToDelete.AGTPexterno eq 1>
				<cfset alertasisext = true>
			</cfif>
		</cfif>
	<cfelseif IDtrans EQ 11>
    	<cfquery name="rsCheckToDelete" datasource="#session.dsn#">
			select AFESid
			from AFEntradaSalidaE
			where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfif (rsCheckToDelete.RecordCount gte 1)>
			<cfquery name="rsDelete0" datasource="#session.dsn#">
				select count(1) as Registros
				from AFEntradaSalidaD
				where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>

			<cfquery name="rsDelete1" datasource="#session.dsn#">
				delete
				from AFEntradaSalidaD
				where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>

			<cfquery name="rsDelete2" datasource="#session.dsn#">
				delete
				from AFEntradaSalidaE
				where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>

		</cfif>
  </cfif>
	</cfloop>

	<cfif alertasisext>
		<script>alert("Advertencia: Algunos de las transacciones que se marcaron para eliminar, \n no fueron eliminadas debido a que provienen de sistemas externos")</script>
	</cfif>
</cfif>


<!---lista--->
<cf_templateheader title="Activos Fijos">
	  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#botonAccion[IDtrans][3]#">
      <cfset botones = "">
     		 <cfif IDtrans NEQ 200050 >
				<cfset botones = "Aplicar,Eliminar">
            </cfif>
          			<cfif IDtrans EQ 7 >
				<cfset botones = "Eliminar">

			</cfif>
			<cfif IDtrans EQ 10>
				<cfset botones = "Eliminar,Importar">
			</cfif>
            <cfif IDtrans EQ 11>
				<cfset botones = "Nuevo,Eliminar,Aplicar">
			</cfif>


			<cfif (IDtrans EQ 2) or (IDtrans EQ 5) or (IDtrans EQ 7) or (IDtrans EQ 8)>
				<cfset botones = botones>
			</cfif>

      		<cfif (IDtrans EQ 8) or (IDtrans EQ 6) or (IDtrans EQ 5) >
				<cfset botones = botones & ",Importar">
			</cfif>
			<cfif (IDtrans EQ 4)>
				<cfset botones = botones & ",Dep_Manual,Dep_Por_Actividad">
			</cfif>
            <cfset LvarBotones= '#botonAccion[IDtrans][1]#,#botonAccion[IDtrans][4]##iif(len(trim(botonAccion[IDtrans][4])),DE(','),DE(''))##botones#'>
            <cfif (IDtrans EQ 5 and (isdefined("session.LvarJA") and session.LvarJA)) or (IDtrans EQ 2 and (isdefined("session.LvarJA") and session.LvarJA)) or (IDtrans EQ 4 and (isdefined("session.LvarJA") and session.LvarJA))>
	            <cfset LvarBotones = "Aplicar">
            <cfelseif (IDtrans EQ 5 and (isdefined("session.LvarJA") and not session.LvarJA)) or (IDtrans EQ 2 and (isdefined("session.LvarJA") and not session.LvarJA))>
            	<cfset LvarBotones = "Nuevo,Eliminar,Importar">
            <cfelseif (IDtrans EQ 4 and (isdefined("session.LvarJA") and not session.LvarJA))>
            	<cfset LvarBotones = "Generar,Eliminar,Dep_Manual,Dep_Por_Actividad">
            </cfif>
			<cf_dbfunction name="date_format" 	  args="a.AGTPfechaprog,DD/MM/YYYY" 	returnvariable="AGTPfechaprogF">
			<cf_dbfunction name="to_chartime" 	  args="a.AGTPfechaprog" 				returnvariable="AGTPfechaprogH">
			<cf_dbfunction name="to_integer"      args="b.VSvalor" 						returnvariable="VSvalor">
			<cf_dbfunction name="concat" 		  args="'Por Generar <b>Fecha:</B> ' + #AGTPfechaprogF# + ' <b>Hora:</b> ' + #AGTPfechaprogH#" delimiters= "+"  returnvariable="PorGenerar" >
			<cf_dbfunction name="concat" 		  args="'Por Aplicar <b>Fecha:</B> ' + #AGTPfechaprogF# + ' <b>Hora:</b> ' + #AGTPfechaprogH#" delimiters= "+"  returnvariable="PorAplicar" >

            <cfset LvarPar = ''>
            <cfif isdefined("session.LvarJA") and session.LvarJA and ((IDtrans eq 4) or (IDtrans eq 5) or (IDtrans eq 2))>
				<cfset LvarPar = '_JA'>
            <cfelseif isdefined("session.LvarJA") and not session.LvarJA and ((IDtrans eq 4) or (IDtrans eq 5) or (IDtrans eq 2))>
                <cfset LvarPar = '_Aux'>
            </cfif>

<cfif IDtrans NEQ 11>
			<cfquery name="Lista" datasource="#session.dsn#">
				select
				a.AGTPid,
				a.Ecodigo,
				a.IDtrans,
				a.AGTPdescripcion,
				a.AGTPperiodo,
				b.VSdesc as AGTPmesdesc, a.AGTPfalta, a.AGTPestadp,
				case when (a.AGTPexterno = 1) then
					'Sistema Externo'
				else
					''
				end as ImAGTPexterno,
				case when a.AGTPestadp =  0 then 'En Proceso'
				when a.AGTPestadp = 1 then 'PorGenerar'
				when a.AGTPestadp = 2 then 'PorAplicar'
				when a.AGTPestadp = 4 then 'Aplicado'
				else '' end as AGTPestadodesc,
				1 as valido
			from AGTProceso a
			inner join VSidioma b on #VSvalor# = a.AGTPmes and b.VSgrupo=1
			inner join Idiomas c on c.Iid = b.Iid and c.Icodigo = '#Session.Idioma#'
			where #preservesinglequotes(filtro)#
			<cfif isdefined('form.Filtro_AGTPfalta') and len(trim(form.Filtro_AGTPfalta))>
			 and <cf_dbfunction name="to_date00" args="AGTPfalta"> =  <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp" value="#form.Filtro_AGTPfalta#">
			</cfif>
			</cfquery>
<cfelse>

            <cfquery name="rsEntradaSalida" datasource="#session.dsn#">
				select
                a.AFESid,
				a.Descripcion,
				a.AFMSid,
                <cfif isdefined('form.filtro_AFMSdescripcion') and len(trim(form.filtro_AFMSdescripcion))>
                b.AFMSdescripcion,
                <cfelse>
                '' as AFMSdescripcion,
                </cfif>
				a.Fecha,
                case when a.TipoMovimiento =  1 then 'Entrada'
				when a.TipoMovimiento = 2 then 'Salida'
				when a.TipoMovimiento = 3 then 'Comodato'
				when a.TipoMovimiento = 4 then 'Comodato Devuelto' end as AGTPestadodesc,
                1 as valido
			from AFEntradaSalidaE a
             <cfif isdefined('form.filtro_AFMSdescripcion') and len(trim(form.filtro_AFMSdescripcion))>
            	inner join AFMotivosSalida b
                 	on a.AFMSid = b.AFMSid
                    and a.Ecodigo = b.Ecodigo
             </cfif>
                where Aplicado = 0
                and  #preservesinglequotes(filtro)#
			<cfif isdefined('form.Filtro_Fecha') and len(trim(form.Filtro_Fecha))>
			 and <cf_dbfunction name="to_date00" args="Fecha"> =  <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp" value="#form.Filtro_Fecha#">
			</cfif>
            <cfif isdefined('form.Filtro_Descripcion') and len(trim(form.Filtro_Descripcion))>
			 and upper(Descripcion) like '%#Ucase(form.Filtro_Descripcion)#%'
			</cfif>
            <cfif isdefined('form.filtro_AFMSdescripcion') and len(trim(form.filtro_AFMSdescripcion))>
			 and upper(AFMSdescripcion) like '%#Ucase(form.filtro_AFMSdescripcion)#%'
			</cfif>
			</cfquery>
</cfif>
<!---<cfif IDtrans NEQ 11>--->
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
        <cfif IDtrans NEQ 11>
			<cfinvokeargument name="query" 				value="#Lista#"/>
        <cfelse>
			<cfinvokeargument name="query" 				value="#rsEntradaSalida#"/>
		</cfif>
				<cfif IDtrans EQ 5>
					<!--- Para el caso de Retiros se muestra si viene de un sistema externo --->
					<cfinvokeargument name="desplegar" value="AGTPdescripcion, AGTPperiodo, AGTPmesdesc, AGTPfalta, AGTPestadodesc, ImAGTPexterno"/>
					<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Periodo, Mes, Fecha, Estado, "/>
					<cfinvokeargument name="formatos" value="V, V, V, D, V, US"/>
					<cfinvokeargument name="align" value="left, left, left, left, left, left"/>
					<cfinvokeargument name="filtrar_por" value="AGTPdescripcion, AGTPperiodo, VSdesc, AGTPfalta, AGTPestadp, ''"/>

                <cfelseif IDtrans EQ 11>
	                <cfinvokeargument name="desplegar" value="Descripcion, AFMSdescripcion, Fecha , AGTPestadodesc"/>
					<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Motivo, Fecha, Tipo Movimiento"/>
					<cfinvokeargument name="formatos" value="V, V, D, V"/>
					<cfinvokeargument name="align" value="left, left, left, left, left"/>
					<cfinvokeargument name="filtrar_por" value="Descripcion, AFMsid, Fecha, AGTPestadp"/>

				<cfelse>

					<cfinvokeargument name="desplegar" value="AGTPdescripcion, AGTPperiodo, AGTPmesdesc, AGTPfalta, AGTPestadodesc"/>
					<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Periodo, Mes, Fecha, Estado"/>
					<cfinvokeargument name="formatos" value="V, V, V, D, V"/>
					<cfinvokeargument name="align" value="left, left, left, left, left"/>
					<cfinvokeargument name="filtrar_por" value="AGTPdescripcion, AGTPperiodo, VSdesc, AGTPfalta, AGTPestadp"/>

				</cfif>
                    <cfinvokeargument name="ajustar" value="N"/>
                    <cfinvokeargument name="irA" value="agtProceso_#botonAccion[IDtrans][7]#_#botonAccion[IDtrans][2]##LvarPar#.cfm"/>
                    <cfinvokeargument name="checkboxes" value="S"/>
                    <cfinvokeargument name="formname" value="fagtproceso"/>
           		<cfif IDtrans NEQ 11>
                    <cfinvokeargument name="keys" value="AGTPid"/>
                    <cfinvokeargument name="inactivecol" value="valido"/>
	            <cfelse>
                    <cfinvokeargument name="keys" value="AFESid"/>
                    <cfinvokeargument name="inactivecol" value="valido"/>
	            </cfif>
                    <cfinvokeargument name="botones" value="#LvarBotones#"/>
                    <cfinvokeargument name="navegacion" value="#navegacion#"/>
                    <cfinvokeargument name="mostrar_filtro" value="true"/>
                    <cfinvokeargument name="filtrar_automatico" value="true"/>
                    <cfinvokeargument name="rsAGTPestadodesc" value="#rsEstados#"/>
                    <cfinvokeargument name="MaxRows" value="15"/>


			</cfinvoke>

             <cfif IDtrans EQ 200050>
             <div align="center" style="color:#F00"><p>Generación Automatica de Placas activada. No se permite usar esta opción!</p></div>


			</cfif>
		<cf_web_portlet_end>
	<cf_templatefooter>


<!---funciones en javascript de los botones--->
<script language="javascript" type="text/javascript">
<!--//
	function algunoMarcado(){
		var aplica = false;
		var form = document.fagtproceso;
		if (form.chk) {
			if (form.chk.value) {
				aplica = form.chk.checked;
			} else {
				for (var i=0; i<form.chk.length; i++) {
					if (form.chk[i].checked) {
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (aplica);
		} else {
			alert('Debe seleccionar al menos un grupo de transacciones antes de realizar esta acción!');
			return false;
		}
	}
	<cfoutput>
	function funcEliminar(){

		if (algunoMarcado() && confirm("Está seguro de que desea eliminar los grupos de transacciones seleccionados?"))
			document.fagtproceso.action = "#CurrentPage#?#params#";
		else
			return false;
	}
	function funcAplicar(){
		if (algunoMarcado() && confirm("Está seguro de que desea aplicar los grupos de transacciones seleccionados?"))
			document.fagtproceso.action = "agtProceso_#botonAccion[IDtrans][5]#_#botonAccion[IDtrans][2]##LvarPar#.cfm?#params#";
		else
			return false;
	}

	<cfif (IDtrans EQ 8)>
	function funcImportar()
	{
		document.fagtproceso.action='Traslados-import.cfm';
		document.fagtproceso.submit();
	}
	<cfelseif (IDtrans EQ 6)>
	function funcImportar()
	{
		document.fagtproceso.action='agtProceso_Importa.cfm?number=1&IDtrans=6';
		document.fagtproceso.submit();
	}
	<cfelseif (IDtrans EQ 10)>
	function funcImportar()
	{
		document.fagtproceso.action='agtProceso_importaPlaca.cfm';
		document.fagtproceso.submit();
	}
	</cfif>
	function funcDep_Manual()
	{
		document.fagtproceso.action = "agtProceso_genera_DepManual#LvarPar#.cfm?#params#";
		//document.fagtproceso.submit();
	}
	function funcDep_Por_Actividad()
	{
		document.fagtproceso.action = "agtProceso_genera_DepPorActidad#LvarPar#.cfm?#params#";
		//document.fagtproceso.submit();
	}
	function func#botonAccion[IDtrans][1]#(){
		document.fagtproceso.action = "agtProceso_genera_#botonAccion[IDtrans][2]##LvarPar#.cfm?#params#";
	}
	<cfif len(trim(botonAccion[IDtrans][4]))>
	function func#botonAccion[IDtrans][4]#(){
		if (algunoMarcado()){
			document.fagtproceso.action = "agtProceso_programa_#botonAccion[IDtrans][2]##LvarPar#.cfm?#params#";
		}
		else
			return false;
	}
	</cfif>
	</cfoutput>



//-->
</script>
