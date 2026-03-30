<cf_templatecss>
<cfparam name="url.RHEid" default="0">
<cfparam name="url.RHSAid" default="0">
<cfparam name="modo" default="alta">

<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script type="text/javascript" language="javascript1.2">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	function funcEliminar(prn_RHCSAid){
		if( confirm('¿Desea Eliminar el Registro?') ){
			if(prn_RHCSAid)
				document.formComponentes.RHCSAidEliminar.value = prn_RHCSAid;
			else{
				document.formComponentes.RHSAidEliminar.value = document.formComponentes.RHSAid.value;
				document.formComponentes.action = 'SP-PPresupuestarias-sql.cfm';
			}
			document.formComponentes.submit();
		}
		return false;	
	}

</script>

<!----////////////////////////// INSERTAR NUEVO COMPONENTE, ELIMINAR UNO, O MODIFICAR////////////////////////////////////----->
<cfif isdefined("form.btn_nuevo") or isdefined("form.btn_modifica") or (isdefined("form.RHCSAidEliminar") and len(trim(form.RHCSAidEliminar))) or isdefined('form.Modificar')>
	<!---Insertado de nuevo componente salarial---->
	<cfif 	isdefined("form.btn_nuevo")  
			and isdefined("form.RHEid") and len(trim(form.RHEid)) 
			and isdefined("form.RHSAid") and len(trim(form.RHSAid))>	
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>

		<cftransaction>			
			<cfquery name="rsMoneda" datasource="#session.DSN#">
				select Mcodigo
				from Empresas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfquery name="Inserta" datasource="#session.DSN#">
				insert into RHCSituacionActual(RHSAid, 
												CSid, 
												Ecodigo, 
												Cantidad, 
												Monto,
												CFformato, 
												BMfecha, 
												BMUsucodigo)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_float" value="#form.CantidadNuevo#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.MontoNuevo,',','','all')#">,
							<cfif isdefined("form.CScomplemento") and len(trim(form.CScomplemento))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CScomplemento#"><cfelse>null</cfif>,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
							)
			</cfquery>				
		</cftransaction>	
	<!----Modificacion de montos------>
	<cfelseif isdefined("form.btn_modifica") and isdefined("form.RHCSAid") and len(trim(form.RHCSAid))>
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cftransaction>
			<cfloop list="#form.RHCSAid#" index="i">	
				<cfif isdefined("form.Monto_#i#") and len(trim(form['Monto_#i#']))>
					<cfquery datasource="#session.DSN#">
						update RHCSituacionActual 						
							set Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['Monto_#i#'],',','','all')#">						
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHCSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">						
					</cfquery>
				</cfif>			
			</cfloop>
		</cftransaction>		
	<!----Borrado de componente---->
	<cfelseif isdefined("form.RHCSAidEliminar") and len(trim(form.RHCSAidEliminar))>
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cftransaction>
			<cfquery name="Delete" datasource="#session.DSN#">
				delete from RHCSituacionActual
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHCSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCSAidEliminar#">	
			</cfquery>
		</cftransaction>
    <cfelseif isdefined('form.Modificar')and isdefined("form.RHEid") and len(trim(form.RHEid)) and isdefined("form.RHSAid") and len(trim(form.RHSAid))>
    	<cfquery name="rsDatos" datasource="#session.DSN#">
            select RHCid, RHMPPid,RHTTid,RHPPid
            from RHSituacionActual
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">	
        </cfquery>
        <cfquery name="rsValidaFechas" datasource="#session.DSN#">
			select count(1) as Registros
			from RHSituacionActual
			where (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhastaplaza)#"> between fdesdeplaza and fhastaplaza
                or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesdeplaza)#"> between fdesdeplaza and fhastaplaza)
                <cfif isdefined('url.RHSPid')>
                	and RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
                </cfif>
				<cfif len(trim(rsDatos.RHCid))>
					and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHCid#">
				</cfif>
				<cfif len(trim(rsDatos.RHTTid))>
					and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHTTid#">
				</cfif>
				<cfif len(trim(rsDatos.RHMPPid))>
					and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHMPPid#">
				</cfif>
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
              and RHSAid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">		
		</cfquery>
		<cfif isdefined("rsValidaFechas") and rsValidaFechas.RecordCount NEQ 0 and rsValidaFechas.Registros NEQ 0>
            <script type="text/javascript" language="javascript1.2">
                alert("Las fechas del corte se traslapan con otros registros ya existentes.");
            </script>
        <cfelse>
            <cftransaction>
                <cfquery datasource="#session.DSN#">
                    update RHEscenarios
                        set RHEcalculado = 0
                    where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
                </cfquery>
                <cfquery datasource="#session.DSN#">
                    update RHSituacionActual set
                        fdesdeplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesdeplaza)#">,
                        fhastaplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhastaplaza)#">
                    where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
                      and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">
                </cfquery>
               <cfset lvarExiste = true>
                <cfset i = 1>
                <cfloop  condition="#lvarExiste#">
                    <cfif isdefined('RHCSAid_#i#')>
                        <cfset lvarRHCSAid = evaluate('RHCSAid_#i#')>
                        <cfset lvarMonto = evaluate('MontoRes_#i#')>
                        <cfquery datasource="#session.dsn#">
                            update RHCSituacionActual set
                                Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(lvarMonto,',','','all')#">
                            where RHCSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHCSAid#">
                        </cfquery>
                    <cfelse>
                        <cfset lvarExiste = false>
                    </cfif>
                    <cfset i = i + 1>
                </cfloop>
            </cftransaction>
        </cfif>
	</cfif>	
</cfif>
<cfset ValuesCambioTablas = ArrayNew(1)>	<!---Valores de la tabla salarial---->
<cfset ValuesCambioCategoria = ArrayNew(1)>	<!---Valores de la Categoria---->
<cfset ValuesCambioPuesto = ArrayNew(1)>	<!---Valores del Puesto---->
<cfset rsCfuncional = QueryNew('CFid')>		<!--- Centro Funcional Query --->
<cfset LvarFechaDesde = "">					<!--- Fecha Desde --->
<cfset LvarFechaHasta = "">					<!--- Fecha hasta --->
<!----////////////////////////////////DATOS DEL FRAME DE COMPONENTES/////////////////////////////////----->
<cfif (isdefined("url.RHSAid") and len(trim(url.RHSAid))) and (isdefined("url.RHEid") and len(trim(url.RHEid)))>
		<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<cfquery name="rsComponentes" datasource="#session.DSN#">		
		select 	csa.CSid,
				csa.RHSAid,
				csa.RHCSAid,
				csa.Cantidad,
				csa.Monto as MontoRes,
				0 as MontoBase,
				csa.ts_rversion,
				ltrim(rtrim(cmp.CScodigo)) as Codigo,
				ltrim(rtrim(cmp.CSdescripcion)) as CSDescripcion,
				RHMCcomportamiento,
				CSusatabla,
				case cmp.CSsalariobase 
					when 1 then ''
				else '<img border=''0'' onClick=''javascript: funcEliminar("'#LvarCNCT# <cf_dbfunction name="to_char" args="csa.RHCSAid"> #LvarCNCT#'");'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>' end as eliminar				 
		from RHSituacionActual sa
		inner join RHCSituacionActual csa
			on csa.RHSAid = sa.RHSAid
			inner join ComponentesSalariales cmp
				on cmp.CSid = csa.CSid
				and cmp.Ecodigo = csa.Ecodigo
		 left outer join RHMetodosCalculo c
				 on c.Ecodigo = csa.Ecodigo
				 and c.CSid = csa.CSid
				 and sa.fdesdeplaza between c.RHMCfecharige and c.RHMCfechahasta
				 and c.RHMCestadometodo = 1
		where csa.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and csa.RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHSAid#">
		order by cmp.Codigo, cmp.CSdescripcion
	</cfquery>
	<!---Datos de la Plaza---->
	<cfquery name="rsPlazaRH" datasource="#session.DSN#">
		select ltrim(rtrim(coalesce(c.RHPcodigo,e.RHMPPcodigo))) as Codigo,ltrim(rtrim(coalesce(c.RHPdescpuesto,e.RHMPPdescripcion))) as PlazaSolic
		from RHSituacionActual a
			inner join RHSolicitudPlaza b
				on a.RHSPid = b.RHSPid 
				and a.Ecodigo = b.Ecodigo
					
				left outer join RHPuestos c
					on b.RHPcodigo = c.RHPcodigo
					and b.Ecodigo = c.Ecodigo
				left outer join RHMaestroPuestoP e
                	on e.RHMPPid = b.RHMPPid
                    and e.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">
			and a.RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHSAid#">
	</cfquery>
	<!----Fechas del escenario--->
	<cfquery name="rsEscenario" datasource="#session.DSN#">	
		select RHEfdesde, RHEfhasta from RHEscenarios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">
	</cfquery>
    <cfquery name="rsComponente" datasource="#session.DSN#">		
        select 	sa.RHSAid, sa.RHTTid, sa.RHMPPid, sa.RHCid, sa.CFid, sa.fdesdeplaza, sa.fhastaplaza, RHSPid
        from RHSituacionActual sa
        where sa.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
            and sa.RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHSAid#">
    </cfquery>
    <cfset LvarFechaDesde = LSDateFormat(rsComponente.fdesdeplaza,'DD/MM/YYYY')>
    <cfset LvarFechaHasta = LSDateFormat(rsComponente.fhastaplaza,'DD/MM/YYYY')>	
    <!---Datos de la tabla---->
    <cfif len(trim(rsComponente.RHTTid))>
        <cfquery name="rsTabla" datasource="#session.DSN#">
            select RHTTcodigo, RHTTdescripcion
            from RHTTablaSalarial
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponente.RHTTid#">				
        </cfquery>		
        <cfset ArrayAppend(ValuesCambioTablas, rsComponente.RHTTid)>
        <cfset ArrayAppend(ValuesCambioTablas, rsTabla.RHTTcodigo)>
        <cfset ArrayAppend(ValuesCambioTablas, rsTabla.RHTTdescripcion)>
    </cfif>
    <!---Datos de la Categoria---->
    <cfif len(trim(rsComponente.RHCid))>
        <cfquery name="rsCategoria" datasource="#session.DSN#">
            select RHCcodigo, RHCdescripcion
            from RHCategoria
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">				
                and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponente.RHCid#">
        </cfquery>			
        <cfset ArrayAppend(ValuesCambioCategoria, rsComponente.RHCid)>
        <cfset ArrayAppend(ValuesCambioCategoria, rsCategoria.RHCcodigo)>
        <cfset ArrayAppend(ValuesCambioCategoria, rsCategoria.RHCdescripcion)>
    </cfif>
    <!---Datos del Puesto---->
    <cfif len(trim(rsComponente.RHMPPid))>
        <cfquery name="rsPuesto" datasource="#session.DSN#">
            select RHMPPcodigo, RHMPPdescripcion
            from RHMaestroPuestoP
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">				
                and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponente.RHMPPid#">
        </cfquery>			
        <cfset ArrayAppend(ValuesCambioPuesto, rsComponente.RHMPPid)>
        <cfset ArrayAppend(ValuesCambioPuesto, rsPuesto.RHMPPcodigo)>
        <cfset ArrayAppend(ValuesCambioPuesto, rsPuesto.RHMPPdescripcion)>
    </cfif>
    <!---Centro Funcional---->
    <cfif len(trim(rsComponente.CFid))>
        <cfquery name="rsCfuncional" datasource="#session.DSN#">
            select CFid,CFcodigo,CFdescripcion 
            from CFuncional 
            where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponente.CFid#">
        </cfquery>
    </cfif>
</cfif>
<cfoutput>
<form name="formComponentes" action="" method="post">
<table width="100%" cellpadding="1" cellspacing="0">

        <input type="hidden" name="RHEid" 	value="#url.RHEid#">
        <input type="hidden" name="RHSAid" value="#url.RHSAid#">
        <input type="hidden" name="RHEfdesde" value="<cfif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfdesde#</cfif>">
        <input type="hidden" name="RHEfhasta" value="<cfif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfhasta#</cfif>">
        <input type="hidden" name="RHSPid" value="#rsComponente.RHSPid#">
        <input type="hidden" name="RHCSAidEliminar" value="">
        <input type="hidden" name="RHSAidEliminar"  value="">
    <tr>
        <td width="14%" nowrap="nowrap" class="tituloListas">
            <strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Puesto Solicitado:</strong>
        </td>
        <td class="tituloListas">
            <cfif isdefined("rsPlazaRH") and rsPlazaRH.RecordCount NEQ 0>
            	<strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">#rsPlazaRH.Codigo# - #rsPlazaRH.PlazaSolic#</strong>
            </cfif>
        </td>
    </tr>
    <tr>
        <td colspan="6">
            <table width="100%" cellpadding="2" cellspacing="0">				
                <tr>
                    <td width="25%"><strong>&nbsp;Tabla Salarial:&nbsp;</strong></td>
                    <td width="20%" ><strong>&nbsp;Puesto:&nbsp;</strong></td>
                    <td width="20%" ><strong>&nbsp;Categor&iacute;a:&nbsp;</strong></td>
                </tr>
                <tr>
                    <!---Tablas salariales---->
                    <td width="25%">
                        <cf_conlis 
                            campos="RHTTid,RHTTcodigo,RHTTdescripcion"
                            asignar="RHTTid,RHTTcodigo,RHTTdescripcion"
                            size="0,8,25"
                            desplegables="N,S,S"
                            modificables="N,S,N"							
                            title="Lista de Tablas Salariales"
                            tabla="RHTTablaSalarial"
                            columnas="RHTTid,RHTTcodigo,RHTTdescripcion"
                            filtro="Ecodigo = #Session.Ecodigo# 									
                                    Order by RHTTcodigo,RHTTdescripcion"
                            filtrar_por="RHTTcodigo,RHTTdescripcion"
                            desplegar="RHTTcodigo,RHTTdescripcion"
                            etiquetas="C&oacute;digo, Descripci&oacute;n"
                            formatos="S,S"
                            align="left,left"						
                            asignarFormatos="S,S,S"
                            form="formComponentes"
                            showEmptyListMsg="true"
                            valuesArray="#ValuesCambioTablas#"
                            readonly="true"	
                            EmptyListMsg=" --- No se encontraron registros --- "/>				
                    </td>
                    <!----Puestos---->
                    <td width="20%">
                        <cf_conlis 
                            campos="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
                            asignar="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
                            size="0,8,25"
                            desplegables="N,S,S"
                            modificables="N,S,N"
                            title="Lista de Puestos Presupuestarios"
                            tabla="RHMaestroPuestoP"
                            columnas="RHMPPid,RHMPPcodigo,RHMPPdescripcion"							
                            filtro="Ecodigo = #Session.Ecodigo# Order by RHMPPcodigo,RHMPPdescripcion"
                            filtrar_por="RHMPPcodigo,RHMPPdescripcion"
                            desplegar="RHMPPcodigo,RHMPPdescripcion"
                            etiquetas="C&oacute;digo, Descripci&oacute;n"
                            formatos="S,S,S,"
                            align="left,left"						
                            asignarFormatos="S,S,S"
                            form="formComponentes"
                            showEmptyListMsg="true"		
                            valuesArray="#ValuesCambioPuesto#"
                            readonly="true"			
                            EmptyListMsg=" --- No se encontraron registros --- "/>					
                    </td>
                    <!----Categorias---->
                    <td width="20%">
                        <cf_conlis 
                            campos="RHCid,RHCcodigo,RHCdescripcion"
                            size="0,8,25"
                            desplegables="N,S,S"
                            modificables="N,S,N"
                            title="Lista de Categor&iacute;as"
                            tabla="RHCategoria a
                                    inner join RHCategoriasPuesto b
                                        on b.RHCid = a.RHCid"
                            columnas="a.RHCid as RHCid, RHCcodigo as RHCcodigo, RHCdescripcion as RHCdescripcion"
                            filtro="a.Ecodigo = #Session.Ecodigo# and RHMPPid = $RHMPPid,numeric$ Order by RHCcodigo,RHCdescripcion"
                            filtrar_por="RHCcodigo, RHCdescripcion"
                            desplegar="RHCcodigo, RHCdescripcion"
                            etiquetas="C&oacute;digo, Descripci&oacute;n"
                            formatos="S,S"
                            align="left,left"	
                            asignar="RHCid,RHCcodigo, RHCdescripcion"
                            asignarFormatos="S,S,S"
                            form="formComponentes"
                            showEmptyListMsg="true"
                            valuesArray="#ValuesCambioCategoria#"	
                            readonly="true"	
                            EmptyListMsg=" --- No se encotraron registros --- "/>					
                    </td>	         
                </tr>
                <tr>
                    <td width="20%"><strong>&nbsp;Ctro.Funcional:&nbsp;</strong></td>
                    <td width="15%" nowrap="nowrap">
                        <table width="100%"><tr>
                            <td width="50%" nowrap="nowrap"><strong>&nbsp;Fecha Desde:&nbsp;</strong></td>						
                            <td width="50%" nowrap="nowrap"><strong>&nbsp;Fecha Hasta:&nbsp;</strong></td>
                        </tr></table>					</td>
                    <td width="15%" ><strong>&nbsp;</strong></td>
                </tr>
                <tr>
                    <!---Centro funcional---->
                    <td><cf_rhcfuncional id="CFid" form="formComponentes" size="25" query="#rsCfuncional#" readonly="true"></td>
                    <!----Fecha desde---->
                    <td nowrap="nowrap" valign="middle">
                        <table width="100%" border="0"><tr>
                            <td width="50%" nowrap="nowrap"><cf_sifcalendario conexion="#session.DSN#" form="formComponentes" name="fdesdeplaza" value="#LvarFechaDesde#"></td>
                            <td width="50%" nowrap="nowrap"><cf_sifcalendario conexion="#session.DSN#" form="formComponentes" name="fhastaplaza" value="#LvarFechaHasta#"></td>
                        </tr></table>					
                    </td>
                    <td align="center"><cf_botones values="Nuevo Corte,Modificar,Eliminar" names="NuevoCorte,Modificar,Eliminar"></td>
                </tr>
                <tr><td>&nbsp;</td></tr>
            </table>
        </td>
    </tr>
    <tr><td class="tituloListas" colspan="6">&nbsp;</td></tr>
    <tr bgcolor="##CCCCCC">
        <td colspan="6">
            <cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
                select coalesce(Pvalor,'0') as  Pvalor
                from RHParametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                and Pcodigo = 1040
            </cfquery>
            <cfif isdefined("rsSumComponentesAccion.Total") and len(trim(rsSumComponentesAccion.Total))>
                <cfset vTotal = rsSumComponentesAccion.Total >
            <cfelse>
                <cfset vTotal = 0 >
            </cfif>
            <cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
            	<cfinvokeargument name="id" value="#url.RHSAid#">
                <cfinvokeargument name="query" value="#rsComponentes#">
                <cfinvokeargument name="totalComponentes" value="#vTotal#">
                <cfinvokeargument name="MostrarSalarioNominal" value="#rsMostrarSalarioNominal.Pvalor#">
                <cfinvokeargument name="sql" value="4">
                <cfinvokeargument name="readonly" value="false">
                <cfinvokeargument name="permiteAgregar" value="yes">
                <cfinvokeargument name="funcionEliminar" value="funcEliminar">
                <cfinvokeargument name="unidades" value="Cantidad">
                <cfinvokeargument name="montobase" value="MontoBase">
                <cfinvokeargument name="montores" value="MontoRes">
                <cfinvokeargument name="mostrarTotales" value="false">
                <cfinvokeargument name="linea" value="RHCSAid">
                <cfinvokeargument name="formName" value="formComponentes">
           	</cfinvoke>	
		</td>
	</tr>
</table>
</form>
<script language="JavaScript" type="text/javascript">	
	
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function funcHabilitarValidacion(){
		objForm.MontoNuevo.required = true;
		objForm.CantidadNuevo.required = true;
		objForm.CSid.required = true;		
	}
	
	function funcNuevoCorte(){
		var params ="?solicitudPlaza=1&RHSPid=#rsComponente.RHSPid#&RHEid="+document.formComponentes.RHEid.value+'&RHSAid='+document.formComponentes.RHSAid.value;
		popUpWindow("/cfmx/rh/planillap/operacion/PopUp-SANuevoCorte.cfm"+params,200,180,500,270);	
		return false;			
	}
	
</script>
</cfoutput>