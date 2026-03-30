
<cfset def = QueryNew("CFid")>
<cfparam name="Attributes.query" 		default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.aprobacionSP"	default="no" type="boolean"> 
<cfparam name="Attributes.cambiarSP"	default="no" type="boolean"> 
<cfparam name="Attributes.todos"		default="no" type="boolean">
<cfparam name="Attributes.tabindex"		default="" type="string">
<cfparam name="Attributes.soloInicializar"	default="false" type="boolean">
<cfparam name="Attributes.readonly"		default="false" type="boolean">
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("form.cboCFid")>
	<cfset session.Tesoreria.CFid = form.cboCFid>
<cfelseif isdefined("form.CFid")>
	<cfset session.Tesoreria.CFid = form.CFid>
<cfelseif ListLen('Attributes.query.columnList')>
	<cfset session.Tesoreria.CFid = Attributes.query.CFid>
</cfif>
<cfparam name="session.Tesoreria.CFid" default="">
<cfif trim(session.Tesoreria.CFid) EQ "">
	<cfset session.Tesoreria.CFid = -1>
</cfif>

<cfif Attributes.aprobacionSP>
	<cfparam name="form.cboCFid"						default="#session.Tesoreria.CFid#">
	<cfparam name="session.Tesoreria.CFid_subordinados"	default="0">
	<cfparam name="form.cboCFid_subordinados"			default="#session.Tesoreria.CFid_subordinados#">
	<cfparam name="session.Tesoreria.CFid_padre"		default="-1">
	<cfif session.Tesoreria.CFid EQ -1>
		<cfset session.Tesoreria.CFid				= -1>
		<cfset session.Tesoreria.CFid_subordinados	= 0>
		<cfset session.Tesoreria.CFid_padre			= -1>
		<cfset session.Tesoreria.CFid_path			= "">
	<cfelseif session.Tesoreria.CFid_subordinados NEQ form.cboCFid_subordinados>
		<cfif form.cboCFid_subordinados EQ 0>
			<cfset session.Tesoreria.CFid_subordinados	= 0>
			<cfset session.Tesoreria.CFid				= session.Tesoreria.CFid_padre>
			<cfset session.Tesoreria.CFid_padre			= -1>
			<cfset session.Tesoreria.CFid_path			= "">
		<cfelse>
			<cfset session.Tesoreria.CFid_subordinados	= 1>
			<cfset session.Tesoreria.CFid_padre			= session.Tesoreria.CFid>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				Select cf.CFpath
				  from CFuncional cf
				 where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">
			</cfquery>
			<cfset session.Tesoreria.CFid_path			= rsSQL.CFpath>
		</cfif>
	</cfif>
<cfelse>
	<cfset session.Tesoreria.CFid_subordinados	= 0>
	<cfset session.Tesoreria.CFid_padre			= -1>
	<cfset session.Tesoreria.CFid_path			= "">
</cfif>

<cfquery name="rsTES_U_CF" datasource="#session.dsn#">
	<cfif attributes.readonly and session.Tesoreria.CFid NEQ -1>
		Select cf.CFid, cf.CFcodigo, cf.CFdescripcion, cf.CFpath
		  from CFuncional cf
		 where cf.Ecodigo = #session.Ecodigo#
		   and cf.CFid = #session.Tesoreria.CFid#
		 order by cf.CFpath
	<cfelseif session.Tesoreria.CFid_subordinados EQ 0>
		Select cf.CFid, cf.CFcodigo, cf.CFdescripcion #LvarCNCT# ' (<cf_translate key = LB_Oficina xmlfile = "/sif/tesoreria/Solicitudes/cboCFId.xml"> Oficina </cf_translate>: ' #LvarCNCT# o.Oficodigo #LvarCNCT# ')' as CFdescripcion, cf.CFpath
		  from TESusuarioSP tu
			inner join CFuncional cf
				inner join Oficinas o
					 on o.Ecodigo = cf.Ecodigo
					and o.Ocodigo = cf.Ocodigo
				on cf.CFid = tu.CFid
		 where tu.Usucodigo = #session.Usucodigo#
		   and tu.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.chkCancelados") AND session.Tesoreria.CFid GT 0>
		   and tu.CFid=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Tesoreria.CFid#">
		</cfif>
		<cfif Attributes.aprobacionSP>
		   and tu.TESUSPaprobador = 1
		   <cfset LvarTipo = "APROBAR SOLICITUDES">
		<cfelse>
		   and tu.TESUSPsolicitante = 1
		   <cfset LvarTipo = "SOLICITAR PAGOS">
		</cfif>
		 order by cf.CFcodigo
	<cfelse>
		Select cf.CFid, cf.CFcodigo, cf.CFdescripcion, cf.CFpath
		  from CFuncional cf
		 where cf.Ecodigo = #session.Ecodigo#
		   and cf.CFpath #LvarCNCT# '/' like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(session.Tesoreria.CFid_path) & "/%"#">
		 order by cf.CFpath
	</cfif>
</cfquery>
<cfif rsTES_U_CF.recordCount EQ 0>
	<cfset Request.Error.Backs = 1>
	<cf_errorCode	code = "50784"
					msg  = "EL USUARIO '@errorDat_1@' NO TIENE AUTORIZACIÓN PARA @errorDat_2@<BR>(Incluirlo en la opción 'Usuarios de Solicitudes de Pago por Empresa')"
					errorDat_1="#session.Usulogin#"
					errorDat_2="#LvarTipo#"
	>
</cfif>

<cfif session.Tesoreria.CFid EQ "-1" AND NOT Attributes.cambiarSP AND NOT Attributes.todos>
	<cfset session.Tesoreria.CFid = rsTES_U_CF.CFid>
</cfif>

<cfif not Attributes.soloInicializar>
	<script language="javascript">
		function sbOnChangeCboCFid(obj)
		{
		<cfif Attributes.cambiarSP>
			var btnCambio = document.getElementById("Cambio");
			if (btnCambio)
			{
				if (!confirm("¿Desea cambiar el Centro Funcional de la Solicitud?"))
					return false;
				btnCambio.click();
				return true;
			}
		</cfif>
		<cfif isdefined("btnNuevo") or isdefined("Nuevo")>
			obj.form.action="?Nuevo";
			obj.form.submit();
		<cfelse>
			obj.form.action="";
			obj.form.submit();
		</cfif>
		}
	</script>
	<select name="cboCFid" id="cboCFid" 
			onchange="return sbOnChangeCboCFid(this);"
			<cfif Attributes.tabindex NEQ "">tabindex="<cfoutput>#Attributes.tabindex#</cfoutput>"</cfif>
	>
	<cfset LvarSelected = false>
	<cfif not attributes.readonly>
		<cfif Attributes.aprobacionSP AND session.Tesoreria.CFid_subordinados EQ 0>
			<option value="-1" <cfif -1 EQ session.Tesoreria.CFid>selected<cfset LvarSelected = true></cfif>>(<cf_translate key = LB_TodosCentrosFuncionales xmlfile = "/sif/tesoreria/Solicitudes/cboCFId.xml">Todos los Centros Funcionales</cf_translate>)</option>
			<option value="0" <cfif 0 EQ session.Tesoreria.CFid>selected<cfset LvarSelected = true></cfif>>(<cf_translate key = LB_SinCentroFuncional xmlfile = "/sif/tesoreria/Solicitudes/cboCFId.xml">Sin Centro Funcional</cf_translate>)</option>
		<cfelseif Attributes.cambiarSP and session.Tesoreria.CFid EQ -1>
			<option value="" selected>(Escoger Centro Funcional)</option>
			<cfset LvarSelected = true>
		<cfelseif Attributes.todos>
			<option value="-1" <cfif -1 EQ session.Tesoreria.CFid>selected<cfset LvarSelected = true></cfif>>(<cf_translate key = LB_TodosCentrosFuncionales xmlfile = "/sif/tesoreria/Solicitudes/cboCFId.xml">Todos los Centros Funcionales</cf_translate>)</option>
			<option value="0" <cfif 0 EQ session.Tesoreria.CFid>selected<cfset LvarSelected = true></cfif>>(<cf_translate key = LB_SinCentroFuncional xmlfile = "/sif/tesoreria/Solicitudes/cboCFId.xml">Sin Centro Funcional</cf_translate>)</option>
		</cfif>			
	</cfif>
	<cfset session.Tesoreria.CFid_subPath = "-1">
	<cfoutput query="rsTES_U_CF">
		<option value="#CFid#" <cfif CFid EQ session.Tesoreria.CFid>selected<cfset LvarSelected = true></cfif>>
			<cfif session.Tesoreria.CFid_subordinados EQ 1>
				<cfif CFid EQ session.Tesoreria.CFid>	
					<cfset session.Tesoreria.CFid_subPath = CFpath>
				</cfif>
				<cfset LvarPto = find("/",CFpath,Len(session.Tesoreria.CFid_path))>
				<cfloop condition="LvarPto GT 0">
					&nbsp;&nbsp;
					<cfset LvarPto = find("/",CFpath,LvarPto+1)>
				</cfloop>
			</cfif>
			#CFcodigo# - #CFdescripcion#
		</option>
	</cfoutput>
	</select>
	<cfif Attributes.aprobacionSP>
		<input	type="hidden" name="cboCFid_subordinados" id="cboCFid_subordinados" value="<cfoutput>#session.Tesoreria.CFid_subordinados#</cfoutput>">
		<input	type="checkbox" 
				onclick="if (this.form.cboCFid.value == '0' || this.form.cboCFid.value == '-1') return false; this.form.cboCFid_subordinados.value='<cfoutput>#abs(session.Tesoreria.CFid_subordinados-1)#</cfoutput>';this.form.action='';this.form.submit();"
				<cfif session.Tesoreria.CFid_subordinados EQ 1>checked</cfif>
		> <cf_translate key=LB_IncluirSubordinados>Incluir subordinados</cf_translate>
	</cfif>
	<cfif NOT LvarSelected AND session.Tesoreria.CFid NEQ -1>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			Select cf.CFid, cf.CFcodigo, cf.CFdescripcion
			  from CFuncional cf
			 where cf.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">
		</cfquery>
		<cfset Request.Error.Backs = 1>
		<cf_errorCode	code = "50785"
						msg  = "EL USUARIO '@errorDat_1@' NO TIENE AUTORIZACIÓN PARA @errorDat_2@ DEL CENTRO FUNCIONAL '@errorDat_3@ - @errorDat_4@'<BR>(Incluirlo en la opción 'Usuarios de Solicitudes de Pago por Empresa')"
						errorDat_1="#session.Usulogin#"
						errorDat_2="#LvarTipo#"
						errorDat_3="#rsSQL.CFcodigo#"
						errorDat_4="#rsSQL.CFdescripcion#"
		>
	</cfif>
</cfif>

<cfquery name="rsSQL" datasource="#session.dsn#">
	select 	e.Edescripcion, cf.CFid, cf.CFcodigo, cf.CFdescripcion,
			coalesce(t_cf.TESid,t_e.TESid) as TESid, 
			coalesce(t_cf.EcodigoAdm, t_e.EcodigoAdm) as EcodigoAdm,
			case  
				when t_cf.TESid is not null then 'CF' 
				when t_e.TESid is not null then 'ED' 
				else 'ERROR' 
			end as tipo
	  from CFuncional cf
		inner join Empresas e
			left join TESempresas te
				inner join Tesoreria t_e
					on t_e.TESid = te.TESid
				on te.Ecodigo = e.Ecodigo
			on e.Ecodigo = cf.Ecodigo
		left join TEScentrosFuncionales tcf
			inner join Tesoreria t_cf
				on t_cf.TESid = tcf.TESid
			on tcf.Ecodigo	= e.Ecodigo
		   and tcf.CFid		= cf.CFid
	 where cf.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">
</cfquery>

<cfif rsSQL.tipo EQ "ERROR">
	<cf_errorCode	code = "50786"
					msg  = "NI EL CENTRO FUNCIONAL '@errorDat_1@ - @errorDat_2@' NI LA EMPRESA '@errorDat_3@' ESTAN ASIGNADOS A NINGUNA TESORERÍA<BR>(Incluirlo en la opción 'Definición de Tesorerías Corporativas')"
					errorDat_1="#rsSQL.CFcodigo#"
					errorDat_2="#rsSQL.CFdescripcion#"
					errorDat_3="#rsSQL.Edescripcion#"
	>
</cfif>

<cfset session.Tesoreria.TESid		= rsSQL.TESid>
<cfset session.Tesoreria.EcodigoAdm	= rsSQL.EcodigoAdm>

