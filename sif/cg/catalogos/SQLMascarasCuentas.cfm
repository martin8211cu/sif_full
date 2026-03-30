<cfparam name="form.PCNDescripCta" default="0">

<cfset DEBUG = false>
<cfif DEBUG>
	<cfdump var="#Form#" expand="yes" label="Form">
	<cfdump var="#Url#" expand="yes" label="Url">
	<cfdump var="#Session#" expand="yes" label="Session">
</cfif>

<cfif isdefined("url.OP") AND isdefined("url.ID1") AND isdefined("url.ID2")>
	<cfquery name="C_PCNivelMascara" datasource="#Session.DSN#">
		update PCNivelMascara
		   set PCNDescripCta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OP#">
		 where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id1#">
		   and PCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id2#">
	</cfquery>			
	<cfabort>
</cfif>

<cfset MODO = "ALTA">
<cfset MODODET = "ALTA">
<cfset ACCIONES = "">
<cfset MODIFICAR_MASCARA = false>
<!-------------------------------------------------------------------------------------------------
								MANTENIMIENTO DE NIVELES DE MÁSCARAS
--------------------------------------------------------------------------------------------------->
<cfif isdefined("form.btnDescripciones")>
	<!--- Ejecuta construcción de Descripcion por nivel --->
	<cf_dbfunction name="OP_concat"	returnvariable="_CAT" datasource="#session.dsn#">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select PCNid as PCNidF, 
			  (select count(1) from PCNivelMascara n2 where n2.PCEMid=n1.PCEMid and n2.PCNid<=n1.PCNid and n1.PCNcontabilidad=1 and n2.PCNcontabilidad=1) as PCNidC, 
			  (select count(1) from PCNivelMascara n2 where n2.PCEMid=n1.PCEMid and n2.PCNid<=n1.PCNid and n1.PCNpresupuesto=1  and n2.PCNpresupuesto=1)  as PCNidP
		  from PCNivelMascara n1 
		 where PCEMid = #form.PCEMid#
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
			   and (select count(1) from PCDCatalogoCuentaF nn where nn.CFcuenta=CFinanciera.CFcuenta and nn.PCEMid = #form.PCEMid#) > 0
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
			   and (select count(1) from PCDCatalogoCuenta nn where nn.Ccuenta=CContables.Ccuenta and nn.PCEMid = #form.PCEMid#) > 0
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
			   and (select count(1) from PCDCatalogoCuentaP nn where nn.CPcuenta=CPresupuesto.CPcuenta and nn.PCEMid = #form.PCEMid#) > 0
		</cfquery>
	</cfif>
<cfelseif not isDefined("form.Nuevo3") 
			and not isDefined("Form.Nuevo") 
			and not isDefined("Form.Alta") 
			and not isDefined("Form.Baja") 
			and not isDefined("Form.Cambio")>

	<cfparam name="form.PCNcontabilidad" default="0">
	<cfparam name="form.PCNpresupuesto"  default="0">

		<cfif (isDefined("form.Alta3") OR isDefined("form.Cambio3")) >
			<cfif form.PCNcontabilidad EQ 0 AND form.PCNpresupuesto EQ 0>
				<cfset request.error.backs = 1>
				<cf_errorCode	code = "50224" msg = "La cuenta debe ser de Contabilidad o Presupuesto">
			</cfif>
			<cfif isdefined("PCNdep") and PCNdep NEQ "">
				<cfquery name="rsPadre" datasource="#Session.DSN#">
					select PCNcontabilidad, PCNpresupuesto
					  from PCNivelMascara
					 where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
					   and PCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCNdep#">
				</cfquery>
				
				<cfif form.PCNcontabilidad EQ 1>
					<cfif rsPadre.PCNcontabilidad EQ 0>
						<cf_errorCode	code = "50225" msg = "El nivel anterior no es de contabilidad">
					</cfif>
				</cfif>
				<cfif form.PCNpresupuesto EQ 1>
					<cfif rsPadre.PCNpresupuesto EQ 0>
						<cf_errorCode	code = "50226" msg = "El nivel anterior no es de presupuesto">
					</cfif>
				</cfif>
				
				<cfquery name="rsLongitud" datasource="#Session.DSN#">
					select min(PCElongitud) as PCElongitud
					  from PCECatalogo hr, PCDCatalogo vr, PCNivelMascara nr
					 where nr.PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
					   and nr.PCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCNdep#">
					   and vr.PCEcatid = nr.PCEcatid
					   and hr.PCEcatid = vr.PCEcatidref
                       and hr.CEcodigo = #session.CEcodigo#
                       and (vr.Ecodigo is null OR vr.Ecodigo = #session.Ecodigo#)
				</cfquery>
				<cfif rsLongitud.PCElongitud NEQ "">
					<cfset form.PCNlongitud = rsLongitud.PCElongitud>
				</cfif>
				<cfif form.PCNlongitud EQ "">
					<cf_errorCode	code = "50227" msg = "No se digito la Longitud">
				</cfif>
			</cfif>
		</cfif>
		<cfparam name="form.PCEcatid" default="">
		<cfif isDefined("form.Alta3") and form.PCEcatid NEQ "">
			<cfquery name="rsCantidad" datasource="#Session.DSN#">
				select count(1) as cantidad
				  from PCNivelMascara
				 where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
				   and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
			</cfquery>
			<cfif rsCantidad.cantidad gt 0>
				<cf_errorCode	code = "50228" msg = "El catálogo ya existe en la mascara">
			</cfif>
		</cfif>

		<cfif isDefined("form.Alta3")>
			<cfquery name="selMaxNivel" datasource="#Session.DSN#">
				select (coalesce(max(PCNid), 0) + 1) as maxNivel 
				from PCNivelMascara
				where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
			</cfquery>
		
			<cfif isdefined('selMaxNivel')>
				<cfquery name="selMaxNivel" datasource="#Session.DSN#">
					insert into PCNivelMascara
							(PCEMid, PCNid, PCEcatid, PCNlongitud, PCNdep, Usucodigo, Ulocalizacion, 
							 PCNcontabilidad, PCNpresupuesto,
							 PCNdescripcion  , PCNDescripCta
							)
					values	(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#selMaxNivel.maxNivel#">, 
								<cfif isDefined("form.PCEcatid") and Len(Trim(Form.PCEcatid)) GT 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#"><cfelse>null</cfif>,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCNlongitud#">, 
								<cfif isDefined("form.PCNdep") and Len(Trim(Form.PCNdep)) GT 0><cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCNdep#"><cfelse>null</cfif>, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCNcontabilidad#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCNpresupuesto#">,
								<cfif isDefined("form.PCNdep") and Len(Trim(Form.PCNdep)) GT 0>
									<cfqueryparam cfsqltype="cf_sql_char" value="#form.PCNdescripcion# (Depende de Nivel #form.PCNdep#)"> 
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_char" value="#form.PCNdescripcion#"> 
								</cfif>
                                ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCNDescripCta#">
							)
				</cfquery>
			</cfif>
			
			<cfset MODIFICAR_MASCARA = true>
			<cfset ACCIONES = ACCIONES & "ALTA DETALLE ">
			<cfset MODODET = "ALTA">
		<cfelseif isDefined("form.Cambio3")>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="PCNivelMascara" 
				redirect="MascarasCuentas.cfm"
				timestamp="#form.ts_rversion#"
				field1="PCEMid,numeric,#form.PCEMid#"
				field2="PCNid,integer,#form.PCNid#">
							
			<cfquery name="C_PCNivelMascara" datasource="#Session.DSN#">
				update PCNivelMascara
					set PCEcatid = 
						<cfif isDefined("form.PCEcatid") and Len(Trim(Form.PCEcatid)) GT 0>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">					
						<cfelse>null</cfif>,					
					PCNlongitud = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCNlongitud#">,
					PCNdep = <cfif isDefined("form.PCNdep") and Len(Trim(Form.PCNdep)) GT 0><cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCNdep#"><cfelse>null</cfif>,
					Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
					PCNcontabilidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCNcontabilidad#">, 
					PCNpresupuesto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCNpresupuesto#">, 
                    PCNDescripCta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCNDescripCta#">,
					PCNdescripcion = 
								<cfif isDefined("form.PCNdep") and Len(Trim(Form.PCNdep)) GT 0>
									<cfqueryparam cfsqltype="cf_sql_char" value="#form.PCNdescripcion# (Depende de Nivel #form.PCNdep#)"> 
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_char" value="#form.PCNdescripcion#"> 
								</cfif>
				where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
					and PCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCNid#">
			</cfquery>			
			
			<cfset MODIFICAR_MASCARA = true>
			<cfset ACCIONES = ACCIONES & "CAMBIO DETALLE ">
			<cfset MODODET = "CAMBIO">
		<cfelseif isDefined("form.Baja3")>
			<cfquery name="selMaxNivel" datasource="#Session.DSN#">
				delete from PCNivelMascara
				where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
				and PCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCNid#">
			</cfquery>
			
			<cfset MODIFICAR_MASCARA = true>
			<cfset ACCIONES = ACCIONES & "BAJA DETALLE ">
			<cfset MODODET = "BAJA">
		</cfif>
			
		<cfif MODIFICAR_MASCARA>
			<cfset fnModificarMascara()>
		</cfif>
	<cfset MODO = "CAMBIO">
		
<cfelseif isdefined("form.Nuevo3")>
	<cfset MODO = "CAMBIO">
	<cfset MODODET = "ALTA">
<!-------------------------------------------------------------------------------------------------
						 				MANTENIMIENTO DE MÁSCARAS
-------------------------------------------------------------------------------------------------->
<cfelseif not isdefined("form.Nuevo")>

		<cfif isdefined("form.Alta")>
			<cfquery name="A_Mascaras" datasource="#Session.DSN#">
				insert INTO PCEMascaras (CEcodigo, PCEMdesc, PCEMformato, PCEMformatoC, Usucodigo, Ulocalizacion,
							PCEMplanCtas, PCEMcodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEMdesc#">, 
					' ', ' ',
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					'00',
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMplanCtas#">,
					<cfqueryparam cfsqltype="cf_sql_char"    value="#form.PCEMcodigo#">
				)				 
			</cfquery>
			
			<cfset ACCIONES = ACCIONES & "ALTA ">
		<cfelseif isdefined("form.Baja")>
			<cfquery name="B1_Mascaras" datasource="#Session.DSN#">
				delete from PCNivelMascara 
				where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
			</cfquery>		
			<cfquery name="B1_Mascaras" datasource="#Session.DSN#">
				delete from PCEMascaras 
				where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			</cfquery>
								
			<cfset ACCIONES = ACCIONES & "BAJA ">
		<cfelseif isdefined("form.Cambio") >
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="PCEMascaras" 
				redirect="MascarasCuentas.cfm"
				timestamp="#form.ts_rversion#"
				field1="PCEMid,numeric,#form.PCEMid#"
				field2="CEcodigo,numeric,#Session.CEcodigo#">		
		
			<cfquery name="C_Mascaras" datasource="#Session.DSN#">
				update PCEMascaras set
					PCEMdesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEMdesc#"> ,
					PCEMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEMcodigo#"> 
					<!--- ,PCEMformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCEMformato#">  --->
					<cfif isdefined("form.PCEMplanCtas")>, PCEMplanCtas = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMplanCtas#"></cfif>
				where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			</cfquery>

			<cfset MODIFICAR_MASCARA = true>
			<cfset ACCIONES = ACCIONES & "CAMBIO ">
			<cfset MODO = "CAMBIO">
		</cfif>

		<cfif MODIFICAR_MASCARA>
			<cfset fnModificarMascara()>
		</cfif>
</cfif>

<cfoutput>
<form action="MascarasCuentas.cfm" method="post" name="form1">
	<cfif MODO eq "CAMBIO">		
		<input name="PCEMid" type="hidden" value="#form.PCEMid#">
	</cfif>
	<input name="MODO" type="hidden" value="#MODO#">
	<input name="MODODET" type="hidden" value="#MODODET#">
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("form.PageNum")>#PageNum#</cfif>">
</form>
</cfoutput>


<html>
<head>
<title>
	SQL de Niveles de Máscaras
</title>
</head>
<body>
<cfif DEBUG>
	ACCIONES = <cfoutput>#ACCIONES#</cfoutput>.
	<a href="javascript: document.form1.submit();">Continuar</a>
<cfelse>
	<script language="JavaScript1.2" type="text/javascript">
		document.form1.submit();
	</script>
</cfif>
</body>
</html>

<cffunction name="fnModificarMascara" output="true">
	<cfquery name="rsMascaras" datasource="#Session.DSN#">
		select PCNlongitud, PCNcontabilidad, PCNpresupuesto
		  from PCNivelMascara
		 where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
		 order by PCNid
	</cfquery>
	<cfset LvarMascaraF = "">
	<cfset LvarMascaraC = "">
	<cfset LvarMascaraP = "">
	<cfset LvarNivelesP = "">
	<cfset LvarPos = "5">
	<cfloop query="rsMascaras">
		<cfset LvarMascaraF = LvarMascaraF & iif(LvarMascaraF EQ "",de(""),de("-")) & RepeatString("X",rsMascaras.PCNlongitud)>
		<cfif rsMascaras.PCNcontabilidad EQ 1>
			<cfset LvarMascaraC = LvarMascaraC & iif(LvarMascaraC EQ "",de(""),de("-")) & RepeatString("X",rsMascaras.PCNlongitud)>
		</cfif>
		<cfif rsMascaras.PCNpresupuesto EQ 1>
			<cfset LvarMascaraP = LvarMascaraP & iif(LvarMascaraP EQ "",de(""),de("-")) & RepeatString("X",rsMascaras.PCNlongitud)>
			<cfset LvarNivelesP = LvarNivelesP & iif(LvarNivelesP EQ "",de("1-4,"),de(",")) & LvarPos & "-" & (rsMascaras.PCNlongitud+1)>
		</cfif>
		<cfset LvarPos = LvarPos + rsMascaras.PCNlongitud + 1>
	</cfloop>
	<cfif LvarMascaraF NEQ "">
		<cfset LvarMascaraF = "XXXX-" & LvarMascaraF>
		<cfset LvarMascaraC = "XXXX-" & LvarMascaraC>
	</cfif>
	<cfif LvarMascaraP NEQ "">
		<cfset LvarMascaraP = "XXXX-" & LvarMascaraP>
		<cfif LvarMascaraF EQ LvarMascaraP>
			<cfset LvarNivelesP = "1-#len(LvarMascaraF)#">
		</cfif>
		
	</cfif>
	<cfif trim(LvarMascaraF) EQ "">
		<cfset LvarMascaraF = " ">
	</cfif>
    <cfif trim(LvarMascaraC) EQ "">
		<cfset LvarMascaraC = " ">
	</cfif>
	<cfquery name="rsMascaras" datasource="#Session.DSN#">
		update PCEMascaras set
			   PCEMformato = '#LvarMascaraF#'
			 , PCEMformatoC = '#LvarMascaraC#'
			 , PCEMformatoP = <cfif LvarMascaraP EQ "">null<cfelse>'#LvarMascaraP#'</cfif>
			 , PCEMnivelesP = <cfif LvarNivelesP EQ ''>null<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarNivelesP#"></cfif>
		 where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
		   and CEcodigo = #Session.CEcodigo#
	</cfquery>
	
	<cfquery datasource="#Session.DSN#">
		update CtasMayor 
		   set Cmascara = '#LvarMascaraF#'
		 where Ecodigo = #session.Ecodigo#
		   and PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		update CtasMayor 
		   set Cmascara = '#LvarMascaraF#'
		 where Ecodigo = #session.Ecodigo#
		   and PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">
	</cfquery>			
</cffunction>


