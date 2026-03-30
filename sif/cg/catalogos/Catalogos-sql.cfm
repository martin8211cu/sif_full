<cfset DEBUG = false>
<cfset Action = "Catalogos.cfm">

<cfif DEBUG>
	<cfdump var="#Form#" expand="yes" label="Form">
	<cfdump var="#Url#" expand="yes" label="Url">
	<cfdump var="#Session#" expand="yes" label="Session">
</cfif>
<cfset ACCIONES = "">
<!--- MODO en que se regresa al form --->
<cfparam name="form.PCDdescripcion" default="">
<cfparam name="form.PCDdescripcionA" default="">
<cfset form.PCDdescripcion	= replace(form.PCDdescripcion,"'","´","ALL")>
<cfset form.PCDdescripcion	= replace(form.PCDdescripcion,'"',"´","ALL")>
<cfset form.PCDdescripcionA	= replace(form.PCDdescripcionA,"'","´","ALL")>
<cfset form.PCDdescripcionA	= replace(form.PCDdescripcionA,'"',"´","ALL")>

<cfif isDefined("form.btnLista")>
	<cflocation url="Catalogos-lista.cfm">
<cfelseif isDefined("url.btnImprime") and url.btnImprime EQ true >
<cfif isDefined("url.porEmpresa")>
	     <cfset VarporEmpresa= "#url.porEmpresa#">
		 </cfif>
		 <cfif isDefined("url.filtro")>
		 <cfset Varfiltro= "#url.filtro#">
		 </cfif>
		 <cfif isDefined("url.PCEcodigo")>
	     <cfset PCEcodigo= "#url.PCEcodigo#">
		 </cfif>
		  <cfif isDefined("url.PCElongitud")>
	     <cfset PCElongitud= "#url.PCElongitud#">
		 </cfif>	
		 <cfif isDefined("url.PCEdescripcion")>
	     <cfset PCEdescripcion= "#url.PCEdescripcion#">
		 </cfif>
		 <cfif isDefined("url.PCEempresa")>
	     <cfset PCEempresa= "#url.PCEempresa#">
		 </cfif>
		 <cfif isDefined("url.PCEoficina")>
	     <cfset PCEoficina= "#url.PCEoficina#">
		 </cfif>
		  <cfif isDefined("url.PCEvaloresxmayor")>
	     <cfset PCEvaloresxmayor= "#url.PCEvaloresxmayor#">
		 </cfif>
		 <cfif isDefined("url.PCEreferenciar")>
	     <cfset PCEreferenciar= "#url.PCEreferenciar#">
		 </cfif>
		 <cfif isDefined("url.PCEreferenciarMayor")>
	     <cfset PCEreferenciarMayor= "#url.PCEreferenciarMayor#">
		 </cfif> 
		 <cfif isDefined("url.PCEactivo")>
	     <cfset PCEactivo= "#url.PCEactivo#">
		 </cfif>
		 <cfif isDefined("url.PCCEdescripcion")>
	     <cfset PCCEdescripcion= "#url.PCCEdescripcion#">
		 </cfif> 
		   
<!---<cfdump var="#url#" >--->
<cfquery name="rsImprime" datasource="#Session.DSN#">
select '#url.F_PCDvalor#' as F_PCDvalor,
       '#url.F_PCDdescripcion#' as F_PCDdescripcion,
	   '#url.F_PCEcatidref#' as F_PCEcatidref,
	   <cfif isdefined("url.LvarIncVal")>'#url.LvarIncVal#' , </cfif>a.PCEcatid as PCEcatid,
	   a.PCDcatid as PCDcatid,
	   d.PCCDvalor as PCCDvalor ,													
	   coalesce(b.PCEdescripcion,'Ninguno') as PCEdescripcion,
	   case PCDactivo when 1 then 'Sí' else 'No' end as PCDactivo,
	   PCDvalor,
	   PCDdescripcion,
	   PCDdescripcionA,
	   case coalesce((select count(1) from PCDCatalogoRefMayor e where e.PCDcatid=a.PCDcatid),0)
	   when 0 then 'No' else 'Sí' end as PCDcatidrefMayor,
	   'CAMBIO' as DMODO
     from 
	   PCDCatalogo a left outer join PCECatalogo b
	    on a.PCEcatidref = b.PCEcatid
		left outer join PCDClasificacionCatalogo c
		inner join PCClasificacionD d
		on c.PCCDclaid = d.PCCDclaid
		on a.PCDcatid = c.PCDcatid 
		where 
		a.PCEcatid = #url.PCEcatid#
	    <cfif isdefined("url.porEmpresa")>#VarporEmpresa#</cfif>
		<cfif isdefined("url.filtro")>#Varfiltro#</cfif>
	 order by PCDvalor
</cfquery>
<!---<cf_dump var="#rsImprime#" >--->
	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
		<cfif url.formato EQ "pdf">
		  <cfset typeRep = 2>
		</cfif>
		<cf_js_reports_service_tag queryReport = "#rsImprime#" 
				isLink = False 
				typeReport = #typeRep#
				fileName = "cg.catalogos.consultas.detalleCatalogo"
				headers = "title:Datos de Configuración del Catálogo"/>
	<cfelse>
	  <cfreport format="#url.formato#" template= "../consultas/detalleCatalogo.cfr" query="rsImprime">
		<cfreportparam name="PCEcodigo" value="#PCEcodigo#">
		<cfreportparam name="PCElongitud" value="#PCElongitud#">
		<cfreportparam name="PCEdescripcion" value="#PCEdescripcion#">
		<cfreportparam name="PCEempresa" value="#PCEempresa#">
		<cfreportparam name="PCEoficina" value="#PCEoficina#">
		<cfreportparam name="PCEvaloresxmayor" value="#PCEvaloresxmayor#">
		<cfreportparam name="PCEreferenciar" value="#PCEreferenciar#">
		<cfreportparam name="PCEreferenciarMayor" value="#PCEreferenciarMayor#">
		<cfreportparam name="PCEactivo" value="#PCEactivo#">
		<cfreportparam name="PCCEdescripcion" value="#PCCEdescripcion#">
		</cfreport>
	</cfif>
</cfif>
<cfset MODO = "ALTA">
<!--- si viene definido el boton de nuevo regresa al form en modo ALTA --->
<cfif not (isDefined("form.Nuevo") or isDefined("form.DNuevo"))>
	<cftry>
		<cfparam name="form.PCEempresa" default="0">
		<cfset LvarEsCorporativo = (form.PCEempresa EQ "0")>
		<cfif (isDefined("form.DAlta") and isDefined("form.PCEcatid") and len(trim(form.PCEcatid)) gt 0
			OR isDefined("form.DCambio") and isDefined("form.PCDcatid") and len(trim(form.PCDcatid)) gt 0)
			AND isDefined("form.PCEcatidref") and len(trim(form.PCEcatidref)) gt 0>
			<cfquery name="rsLongitudes" datasource="#Session.DSN#">
				select count(*) as cantidad, min(PCElongitud) as PCElongitud
				  from PCDCatalogo d, PCECatalogo r
				 where d.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
				   and r.PCEcatid = d.PCEcatidref
			</cfquery>

			<cfquery name="rsLongitud" datasource="#Session.DSN#">
				select PCElongitud
				  from PCECatalogo r
				 where r.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidref#">
			</cfquery>
			<cfif rsLongitudes.cantidad GT 0 and rsLongitudes.PCElongitud NEQ rsLongitud.PCElongitud>
				<cferror type='exception' template='../../Utiles/DBmsg.cfm'>
				<cf_errorCode	code = "50212"
								msg  = "Ya existen catálogos referenciados, sólo se pueden referenciar catálogos cuya longitud sea @errorDat_1@<br>(Se intenta referenciar un catálogo cuya longitud es @errorDat_2@)"
								errorDat_1="#rsLongitudes.PCElongitud#"
								errorDat_2="#rsLongitud.PCElongitud#"
				>
			</cfif>
		</cfif>
			<cfif isDefined("form.Alta")>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select count(1) as cantidad
					  from PCECatalogo
					 where CEcodigo 	= #session.CEcodigo#
					   and PCEcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEcodigo#">
				</cfquery>
				<cfif rsSQL.Cantidad GT 0>
					<cf_errorCode	code = "50213"
									msg  = "Ya existe el Código de Catálogo '@errorDat_1@'"
									errorDat_1="#form.PCEcodigo#"
					>
				</cfif>

				<cfif isDefined("form.PCEreferenciarMayor")>
					<cfset Var_PCEreferenciar=1>
				<cfelse>
					<cfif isDefined("form.PCEreferenciar")>
						<cfset Var_PCEreferenciar=1>
					<cfelse>
						<cfset Var_PCEreferenciar=0>
					</cfif>
				</cfif>
			

				<cftransaction>			
					<cfquery name="ABC_Catalogos" datasource="#Session.DSN#">
						insert into PCECatalogo(CEcodigo, PCEcodigo, PCEdescripcion, PCElongitud, PCEempresa, 
												PCEref, PCEreferenciar, PCEactivo, Usucodigo, Ulocalizacion,	
												PCEoficina, PCEreferenciarMayor, PCEvaloresxmayor)
						values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEdescripcion#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCElongitud#">, 
								<cfif NOT LvarEsCorporativo>1<cfelse>0</cfif>, 
								<cfif isDefined("form.PCEref")>1<cfelse>0</cfif>, 
								<cfqueryparam cfsqltype="cf_sql_bit" value="#Var_PCEreferenciar#">, 
								<cfif isDefined("form.PCEactivo")>1<cfelse>0</cfif>, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
								<cfif isDefined("form.PCEoficina")>1<cfelse>0</cfif>, 
								<cfif isDefined("form.PCEreferenciarMayor")>1<cfelse>0</cfif>,
								<cfif isDefined("form.PCEvaloresxmayor")>1<cfelse>0</cfif>
							 )
						 <cf_dbidentity1 datasource="#Session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_Catalogos">

					<cfif form.PCCEclaid neq "">
						<cfquery name="rsPCEclas" datasource="#Session.DSN#">
							insert into PCEClasificacionCatalogo
								(PCEcatid, PCCEclaid)
							values(
								#ABC_Catalogos.identity#,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCEclaid#">
								)
						</cfquery>
					</cfif>
					
					<cfquery name="rsUsu" datasource="#session.DSN#">				
						insert into PCECatalogoUsr (
												PCEcatid,
												Usucodigo,	
												Ecodigo,
												BMUsucodigo
												)
					values	( 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_Catalogos.identity#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
				</cfquery>
					
				</cftransaction>			

				<!--- Define Volver al form en MODO CAMBIO --->
				<cfset MODO = "CAMBIO">
				<cfset ACCIONES = ACCIONES & "ALTA ">
			<cfelseif (isDefined("form.Cambio") or isDefined("form.DCambio") or isDefined("form.DAlta"))  and isDefined("form.PCEcatid") and len(trim(form.PCEcatid)) gt 0>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select count(1) as cantidad
					  from PCECatalogo
					 where CEcodigo 	= #session.CEcodigo#
					   and PCEcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEcodigo#">
					   and PCEcatid		<> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">		
				</cfquery>
				<cfif rsSQL.Cantidad GT 0>
					<cf_errorCode	code = "50213"
									msg  = "Ya existe el Código de Catálogo '@errorDat_1@'"
									errorDat_1="#form.PCEcodigo#"
					>
				</cfif>

				<!--- REALIZA LA ACTUALIZACION DEL ENCABEZADO --->
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="PCECatalogo" 
					redirect="#Action#"
					timestamp="#form.ts_rversion#"
					field1="PCEcatid,numeric,#form.PCEcatid#">
				
				<cfif isDefined("form.PCEreferenciarMayor")>
					<cfset Var_PCEreferenciar=1>
				<cfelse>
					<cfif isDefined("form.PCEreferenciar")>
						<cfset Var_PCEreferenciar=1>
					<cfelse>
						<cfset Var_PCEreferenciar=0>
					</cfif>
				</cfif>				
				
				
				<cftransaction>
					<cfquery name="C_Catalogos" datasource="#Session.DSN#">
						update PCECatalogo
						set CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
							PCEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEcodigo#">, 
							PCEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEdescripcion#">, 
							PCElongitud = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCElongitud#">, 
							PCEempresa = <cfif NOT LvarEsCorporativo>1<cfelse>0</cfif>, 
							PCEref = <cfif isDefined("form.PCEref")>1<cfelse>0</cfif>, 
							PCEreferenciar = <cfqueryparam cfsqltype="cf_sql_bit" value="#Var_PCEreferenciar#">,  
							PCEactivo = <cfif isDefined("form.PCEactivo")>1<cfelse>0</cfif>, 
							Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
							PCEoficina = <cfif isDefined("form.PCEoficina")>1<cfelse>0</cfif>,
							PCEreferenciarMayor = <cfif isDefined("form.PCEreferenciarMayor")>1<cfelse>0</cfif>,
							PCEvaloresxmayor= <cfif isDefined("form.PCEvaloresxmayor")>1<cfelse>0</cfif>
						where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
					</cfquery>
					<cfif NOT LvarEsCorporativo>
						<cfquery name="C_Catalogos" datasource="#Session.DSN#">
							update PCDCatalogo
							   set PCDdescripcionA = NULL
							 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
							 <cfif isDefined("form.PCDcatid")>
							   and PCDcatid <> #form.PCDcatid#
							 </cfif>
						</cfquery>
					</cfif>
					<cfquery name="rsPCEclas" datasource="#Session.DSN#">
						select PCCEclaid
						  from PCEClasificacionCatalogo E
						 where E.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
					</cfquery>
					<cfif form.PCCEclaid neq rsPCEclas.PCCEclaid>
						<cfquery name="rsPCEclas" datasource="#Session.DSN#">
							delete from PCDClasificacionCatalogo
							 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
						</cfquery>
						<cfquery name="rsPCEclas" datasource="#Session.DSN#">
							delete from PCEClasificacionCatalogo
							 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
						</cfquery>
						<cfif form.PCCEclaid neq "">
							<cfquery name="rsPCEclas" datasource="#Session.DSN#">
								insert into PCEClasificacionCatalogo
									(PCEcatid, PCCEclaid)
								values(
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCEclaid#">
									)
							</cfquery>
						</cfif>
					</cfif>
				</cftransaction>
				<!--- Define Volver al form en MODO CAMBIO --->
				<cfset ACCIONES = ACCIONES & "CAMBIO ">
				<cfset MODO     = "CAMBIO">

			<cfelseif isDefined("form.Baja")  and isDefined("form.PCEcatid") and len(trim(form.PCEcatid)) gt 0>

				<cftransaction>
					<cfquery name="rsPCEclas" datasource="#Session.DSN#">
						delete from PCDClasificacionCatalogo
						 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
					</cfquery>
					<cfquery name="rsPCEclas" datasource="#Session.DSN#">
						delete from PCEClasificacionCatalogo
						 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
					</cfquery>

					<!--- **************************************************************************** --->
					<cfquery name="B3_Catalogos" datasource="#Session.DSN#">
						delete from PCDCatalogoRefMayor
						where exists(select 1
							from PCDCatalogo A
							 where A.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
							   and A.PCDcatid = PCDCatalogoRefMayor.PCDcatid)
					</cfquery>
					
					<cfquery name="B4_Catalogos" datasource="#Session.DSN#">
						delete from PCDCatalogoValOficina
						where exists( select 1
						from PCDCatalogo A						
						 where A.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
						   and A.PCDcatid = PCDCatalogoValOficina.PCDcatid)
					</cfquery>		
					
					<cfquery name="B5_Catalogos" datasource="#Session.DSN#">
						delete from PCDCatalogoPorMayor
						where exists(select 1
							from PCDCatalogo A
							 where A.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
							   and A.PCDcatid = PCDCatalogoPorMayor.PCDcatid)
					</cfquery>
					<!--- **************************************************************************** --->

					<cfquery name="B1_Catalogos" datasource="#Session.DSN#">
						delete from PCDCatalogo
						where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
					</cfquery>
					
					<cfquery name="B2_Catalogos" datasource="#Session.DSN#">
						delete from PCECatalogo
						where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
					</cfquery>
					
					
				</cftransaction>
				
				<cfset ACCIONES = ACCIONES & "BAJA ">
				<cfset Action = "Catalogos-lista.cfm">
			</cfif>

			<cfif isDefined("form.DAlta") and isDefined("form.PCEcatid") and len(trim(form.PCEcatid)) gt 0>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select count(1) as cantidad
					  from PCDCatalogo
					 where coalesce(Ecodigo, #session.Ecodigo#) = #session.Ecodigo#
					   and PCEcatid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">		
					   and PCDvalor	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDvalor#">
				</cfquery>
				<cfif rsSQL.Cantidad GT 0>
					<cf_errorCode	code = "50214"
									msg  = "El valor '@errorDat_1@' ya existe en el Catálogo"
									errorDat_1="#form.PCDvalor#"
					>
				</cfif>

				<cftransaction>
					<cfquery name="A_Catalogos" datasource="#Session.DSN#">
						insert into PCDCatalogo(PCEcatid, PCEcatidref, Ecodigo, PCDactivo, PCDvalor, PCDdescripcion, PCDdescripcionA, Usucodigo, Ulocalizacion)
						values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
								 <cfif isDefined("form.PCEcatidref") and len(trim(form.PCEcatidref)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidref#"><cfelse>null</cfif>,
								 <cfif NOT LvarEsCorporativo><cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"><cfelse>null</cfif>,
								 <cfif (isDefined("form.PCDactivo"))>1<cfelse>0</cfif>,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDvalor#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDdescripcion#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDdescripcionA#" null="#trim(form.PCDdescripcionA) EQ ""#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
								 <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
						)
						<cf_dbidentity1 name="A_Catalogos" datasource="#Session.DSN#">
					</cfquery>
					<cf_dbidentity2 name="A_Catalogos" datasource="#Session.DSN#">
				
					<cfif form.PCCEclaid neq "">
						<cfif form.PCCDclaid eq "">
							<cf_errorCode	code = "50215" msg = "El valor debe ser clasificado">
						</cfif>
						<cfquery datasource="#Session.DSN#">
							insert into PCDClasificacionCatalogo
								(PCEcatid, PCCEclaid,PCDcatid, PCCDclaid)
							values(
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCEclaid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#A_Catalogos.identity#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCDclaid#">
								)
						</cfquery>
					</cfif>
				</cftransaction>

				<cfset MODO = "CAMBIO">
				<cfset ACCIONES = ACCIONES & "DALTA ">
			<cfelseif isDefined("form.DCambio") and isDefined("form.PCDcatid") and len(trim(form.PCDcatid)) gt 0>

				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select count(1) as cantidad
					  from PCDCatalogo
					 where coalesce(Ecodigo, #session.Ecodigo#) = #session.Ecodigo#
					   and PCEcatid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">		
					   and PCDvalor	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDvalor#">
					   and PCDcatid	<> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">				
				</cfquery>
				<cfif rsSQL.Cantidad GT 0>
					<cf_errorCode	code = "50214"
									msg  = "El valor '@errorDat_1@' ya existe en el Catálogo"
									errorDat_1="#form.PCDvalor#"
					>
				</cfif>
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="PCDCatalogo" 
					redirect="#Action#"
					timestamp="#form.dtimestamp#"
					field1="PCDcatid,numeric,#form.PCDcatid#">			

				<cftransaction>
					<cfquery name="rsSQL" datasource="#Session.DSN#">
						select Pvalor
						  from Parametros
						 where Ecodigo = #session.Ecodigo#
						   and Pcodigo = 99
					</cfquery>
					<cfset LvarUsarDescripcionAlterna = (rsSQL.Pvalor EQ "1")>

					<cfquery name="rsSQL" datasource="#Session.DSN#">
						select e.PCEempresa, d.PCDdescripcion, d.PCDdescripcionA, coalesce(d.PCDdescripcionA,d.PCDdescripcion) as PCDdescripcion2
						  from PCDCatalogo d
						  	inner join PCECatalogo e on e.PCEcatid = d.PCEcatid
						 where PCDcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">				
					</cfquery>
					<cfif LvarUsarDescripcionAlterna AND rsSQL.PCEempresa EQ "0">
						<cfparam name="form.PCDdescripcionA" default="">
					<cfelse>
						<cfset form.PCDdescripcionA = "">
					</cfif>

					<cfquery name="C_PCDCatalogo" datasource="#Session.DSN#">
						update PCDCatalogo
						set PCEcatidref    = <cfif isDefined("form.PCEcatidref") and len(trim(form.PCEcatidref)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidref#"><cfelse>null</cfif>, 
							PCDactivo 	   = <cfif (isDefined("form.PCDactivo"))>1<cfelse>0</cfif>, 
							PCDvalor 	   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDvalor#">, 
							PCDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDdescripcion#">, 
							PCDdescripcionA= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDdescripcionA#" null="#trim(form.PCDdescripcionA) EQ ""#">,
							Usucodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							Ulocalizacion  = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
							Ecodigo        = <cfif NOT LvarEsCorporativo><cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"><cfelse>null</cfif>
						where PCDcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">				
					</cfquery>
					
					<cfparam name="form.chkCFdesc" default="0">
					<cfset session.chkCFdesc = form.chkCFdesc>
					<cfif session.chkCFdesc EQ 1>
						<cfif LvarUsarDescripcionAlterna AND rsSQL.PCEempresa EQ "0">
							<cfif form.PCDdescripcionA NEQ "">
								<cfset LvarPCDdescripcion = form.PCDdescripcionA>
							<cfelse>
								<cfset LvarPCDdescripcion = form.PCDdescripcion>
							</cfif>
						<cfelse>
							<cfset LvarPCDdescripcion = form.PCDdescripcion>
						</cfif>
						
						<cfset sbActualizarDescripcion()>
					</cfif>
					
					<cfquery name="rsPCDclas" datasource="#Session.DSN#">
						select PCCDclaid
						  from PCDClasificacionCatalogo E
						 where E.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
					</cfquery>
					<cfif isdefined("form.PCCDclaid") AND form.PCCDclaid neq rsPCDclas.PCCDclaid>
						<cfquery datasource="#Session.DSN#">
							delete from PCDClasificacionCatalogo
							 where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
						</cfquery>
						<cfif form.PCCEclaid NEQ "">
							<cfif form.PCCDclaid eq "">
								<cf_errorCode	code = "50215" msg = "El valor debe ser clasificado">
							</cfif>
							<cfquery datasource="#Session.DSN#">
								insert into PCDClasificacionCatalogo
									(PCEcatid, PCCEclaid,PCDcatid, PCCDclaid)
								values(
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCEclaid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCDclaid#">
									)
							</cfquery>
						</cfif>
					</cfif>
				</cftransaction>
				
				<cfset MODO = "CAMBIO">
				<cfset ACCIONES = ACCIONES & "DCAMBIO ">
			<cfelseif isDefined("form.DBaja") and isDefined("form.PCDcatid") and len(trim(form.PCDcatid)) gt 0>
				<cftransaction>
					<cfquery name="B1_Catalogos" datasource="#Session.DSN#">
						delete from PCDClasificacionCatalogo
						where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
					</cfquery>

					<cfquery name="B2_Catalogos" datasource="#Session.DSN#">
						delete from PCDCatalogoValOficina
						where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
					</cfquery>		
							
					<cfquery name="B3_Catalogos" datasource="#Session.DSN#">
						delete from PCDCatalogoPorMayor
						where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
					</cfquery>
							
					<cfquery name="B4_Catalogos" datasource="#Session.DSN#">
						delete from PCDCatalogoRefMayor
						where PCDcatid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
					</cfquery>
					
					<cfquery name="B_PCDCatalogo" datasource="#Session.DSN#">
						delete from PCDCatalogo
						where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
					</cfquery>
					
				</cftransaction>
				
				<cfset MODO = "CAMBIO">
				<cfset ACCIONES = ACCIONES & "DBAJA ">
			</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		adrian
		<cfabort>
	</cfcatch>
	</cftry>

</cfif>
<cfif isDefined("form.DNuevo")>
	<cfset MODO = "CAMBIO">
</cfif>


<form action="<cfoutput>#Action#</cfoutput>" method="post" name="form1">
	<!--- Valores que se regresan al Form --->
	<cfif MODO eq "CAMBIO">
		<cfif isDefined("form.PCEcatid")>
			<cfset PCEcatid = form.PCEcatid>
		<cfelseif isDefined("ABC_Catalogos")><!--- Solamente puede regresar en MODO CAMBIO si viene definido PCEcatid en el form o en el query --->
			<cfset PCEcatid = ABC_Catalogos.identity>
		<cfelse>
			<cfset MODO = "ALTA">
			<cfset PCEcatid = "">
		</cfif>
		<cfoutput>
		<input name="MODO" type="hidden" value="#MODO#">
		<input name="PCEcatid" type="hidden" value="#PCEcatid#">
		<cfif isDefined("form.Pagina2")>
			<input name="Pagina2" type="hidden" value="#form.Pagina2#">
		</cfif>
		<cfif isDefined("form.F_PCDvalor")>
			<input name="F_PCDvalor" type="hidden" value="#form.F_PCDvalor#">
		</cfif>
		<cfif isDefined("form.F_PCDdescripcion")>
			<input name="F_PCDdescripcion" type="hidden" value="#form.F_PCDdescripcion#">
		</cfif>
		<cfif isDefined("form.DCambio")>
			<input name="PCDcatid" type="hidden" value="#form.PCDcatid#">
			<input name="DMODO" type="hidden" value="CAMBIO">
		</cfif>
		</cfoutput>
	</cfif>
	
	<cfif isdefined("Form.IncVal") and Form.IncVal eq 1>
		<input name="IncVal" type="hidden" id="IncVal" value="<cfoutput>#Form.IncVal#</cfoutput>"/>
	</cfif>	
	
</form>
<html>
<head>
<title>
	SQL de Cat&aacute;logos de Cuentas
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>



<cfif isDefined('form.Cambio') or isDefined('form.DCambio') or isDefined('form.DAlta') or isDefined('form.Baja') or isDefined("form.DBaja")>
	<script language="javascript" type="text/javascript">
	document.form1.submit();
	</script>
</cfif>

<cfif DEBUG>
	ACCIONES = <cfoutput>#ACCIONES#</cfoutput>.
	<a href="javascript: document.form1.submit();">Continuar</a>
<cfelse>
	<!---<script language="javascript" type="text/javascript">
	  <cfif rsactivatejsreports.valParam EQ 0 AND coldfusionV NEQ 2018>
	  
		    document.form1.submit();
		</cfif>
	
	</script>---->
</cfif>
</body>
</html>


<cffunction name="sbActualizarDescripcion" returntype="void">
	<!--- Ejecuta construcción de Descripcion por nivel de cada Mascara que contenga el PCDcatid --->
	<cfquery name="rsPCEMids" datasource="#session.dsn#">
		select distinct nn.PCEMid 
		  from PCDCatalogoCuentaF nn 
		 where nn.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
		   and (select count(1) from PCNivelMascara n2 where n2.PCEMid=nn.PCEMid and PCNDescripCta = 1) > 0
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		update CFinanciera
		   set CFdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarPCDdescripcion#">
			 , CFmovimiento =	case when Ccuenta is not null then 'S' else 'N' end
		 where PCDcatid  		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">				
		<cfif rsPCEMids.recordCount GT 0>
		   and CFmovimiento = 'N'
		</cfif>
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		update CContables
		   set Cdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarPCDdescripcion#">
		 where PCDcatid  		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">				
		<cfif rsPCEMids.recordCount GT 0>
		   and Cmovimiento = 'N'
		</cfif>
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		update CPresupuesto
		   set CPdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarPCDdescripcion#">
		 where PCDcatid  		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">				
		<cfif rsPCEMids.recordCount GT 0>
		   and CPmovimiento = 'N'
		</cfif>
	</cfquery>
	<cfif rsPCEMids.recordCount EQ 0>
		<cfreturn>
	</cfif>
	<cfloop query="rsPCEMids">
		<cfset sbActualizarDescripcionCta(rsPCEMids.PCEMid)>
	</cfloop>
</cffunction>

<cffunction name="sbActualizarDescripcionCta" returntype="void">
	<cfargument name="PCEMid" type="numeric">
	
	<!--- Ejecuta construcción de Descripcion por nivel --->
	<cf_dbfunction name="OP_concat"	returnvariable="_CAT" datasource="#session.dsn#">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select PCNid as PCNidF, 
			  (select count(1) from PCNivelMascara n2 where n2.PCEMid=n1.PCEMid and n2.PCNid<=n1.PCNid and n1.PCNcontabilidad=1 and n2.PCNcontabilidad=1) as PCNidC, 
			  (select count(1) from PCNivelMascara n2 where n2.PCEMid=n1.PCEMid and n2.PCNid<=n1.PCNid and n1.PCNpresupuesto=1  and n2.PCNpresupuesto=1)  as PCNidP
		  from PCNivelMascara n1 
		 where PCEMid = #arguments.PCEMid#
		   and PCNDescripCta = 1
	</cfquery>

	<cfset LvarDescripcion_PCN = "">
	<cfloop list="#valueList(rsSQL.PCNidF)#" index="LvarNiv">
		<cfif LvarNiv NEQ 0>
			<cfif LvarDescripcion_PCN NEQ "">
				<cfset LvarDescripcion_PCN = "#LvarDescripcion_PCN# #_CAT# ' - ' #_CAT# ">
			</cfif>
			<cfset LvarDescripcion_PCN = "#LvarDescripcion_PCN#(select vv.PCDdescripcion from PCDCatalogoCuentaF nn inner join PCDCatalogo vv ON vv.PCDcatid = nn.PCDcatid where nn.CFcuenta=CFinanciera.CFcuenta and nn.PCDCniv = #LvarNiv#)">
		</cfif>
	</cfloop>
	<cfif LvarDescripcion_PCN NEQ "">
		<cfquery name="rsSQL1" datasource="#session.dsn#">
			update CFinanciera
			   set CFdescripcion = #preserveSingleQuotes(LvarDescripcion_PCN)#
			 where Ecodigo = #session.Ecodigo#
			   and CFmovimiento = 'S'
			   and (select count(1) from PCDCatalogoCuentaF nn where nn.CFcuenta=CFinanciera.CFcuenta and nn.PCEMid 	= #arguments.PCEMid#) > 0
			   and (select count(1) from PCDCatalogoCuentaF nn where nn.CFcuenta=CFinanciera.CFcuenta and nn.PCDcatid 	= #form.PCDcatid#) > 0
		</cfquery>
	</cfif>
	
	<cfset LvarDescripcion_PCN = "">
	<cfloop list="#valueList(rsSQL.PCNidC)#" index="LvarNiv">
		<cfif LvarNiv NEQ 0>
			<cfif LvarDescripcion_PCN NEQ "">
				<cfset LvarDescripcion_PCN = "#LvarDescripcion_PCN# #_CAT# ' - ' #_CAT# ">
			</cfif>
			<cfset LvarDescripcion_PCN = "#LvarDescripcion_PCN#(select vv.PCDdescripcion from PCDCatalogoCuenta nn inner join PCDCatalogo vv ON vv.PCDcatid = nn.PCDcatid where nn.Ccuenta=CContables.Ccuenta and nn.PCDCniv = #LvarNiv#)">
		</cfif>
	</cfloop>
	<cfif LvarDescripcion_PCN NEQ "">
		<cfquery name="rsSQL1" datasource="#session.dsn#">
			update CContables
			   set Cdescripcion = #preserveSingleQuotes(LvarDescripcion_PCN)#
			 where Ecodigo = #session.Ecodigo#
			   and Cmovimiento = 'S'
			   and (select count(1) from PCDCatalogoCuenta nn where nn.Ccuenta=CContables.Ccuenta and nn.PCEMid 	= #arguments.PCEMid#) > 0
			   and (select count(1) from PCDCatalogoCuenta nn where nn.Ccuenta=CContables.Ccuenta and nn.PCDcatid 	= #form.PCDcatid#) > 0
		</cfquery>
	</cfif>

	<cfset LvarDescripcion_PCN = "">
	<cfloop list="#valueList(rsSQL.PCNidP)#" index="LvarNiv">
		<cfif LvarNiv NEQ 0>
			<cfif LvarDescripcion_PCN NEQ "">
				<cfset LvarDescripcion_PCN = "#LvarDescripcion_PCN# #_CAT# ' - ' #_CAT# ">
			</cfif>
			<cfset LvarDescripcion_PCN = "#LvarDescripcion_PCN#(select vv.PCDdescripcion from PCDCatalogoCuentaP nn inner join PCDCatalogo vv ON vv.PCDcatid = nn.PCDcatid where nn.CPcuenta=CPresupuesto.CPcuenta and nn.PCDCniv = #LvarNiv#)">
		</cfif>
	</cfloop>
	<cfif LvarDescripcion_PCN NEQ "">
		<cfquery name="rsSQL1" datasource="#session.dsn#">
			update CPresupuesto
			   set CPdescripcion = #preserveSingleQuotes(LvarDescripcion_PCN)#
			 where Ecodigo = #session.Ecodigo#
			   and CPmovimiento = 'S'
			   and (select count(1) from PCDCatalogoCuentaP nn where nn.CPcuenta=CPresupuesto.CPcuenta and nn.PCEMid	= #arguments.PCEMid#) > 0
			   and (select count(1) from PCDCatalogoCuentaP nn where nn.CPcuenta=CPresupuesto.CPcuenta and nn.PCDcatid 	= #form.PCDcatid#) > 0
		</cfquery>
	</cfif>

</cffunction>