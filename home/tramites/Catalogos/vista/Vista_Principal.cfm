<!--- 
	Creado por Gustavo Fonseca Hernández
		Fecha: 16-8-2005.
		Motivo: Mantenimiento de la tabla DDVista.
 --->

<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->




<cf_template>
	<cf_templatearea name="title">Lista de Vistas</cf_templatearea>
	<cf_templatearea name="body">

		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>
		
		<cfif isdefined("url.id_tipo") and len(trim(url.id_tipo)) and not isdefined("form.id_tipo")>
			<cfset form.id_tipo = url.id_tipo>
		</cfif>
		<cfif isdefined("url.id_vista") and len(trim(url.id_vista)) and not isdefined("form.id_vista")>
			<cfset form.id_vista = url.id_vista>
		</cfif>
		<cfparam name="form.id_tipo" default="">
		<cfif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		</cfif>
		<cfif not ( isdefined("form.tab") and ListContains('1,2,3', form.tab) )>
			<cfset form.tab = 1 >
		</cfif> 

		<cfif isdefined("url.id_vista") and not isdefined("form.id_vista")>
			<cfset form.id_vista = url.id_vista>
		</cfif>
				
		<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>		
		
<cfif IsDefined('form.id_vista') and Len(form.id_vista)>
		
		<!--- Valida que esta vista tenga por lo menos un grupo, sino se lo crea --->
		<cfquery name="rsBuscaGrupo" datasource="#session.tramites.dsn#">
			select count(1) as encontrado
			from DDVistaGrupo
			where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
		</cfquery>
		
		<cfif isdefined("rsBuscaGrupo") and rsBuscaGrupo.encontrado EQ 0>
			<cfquery datasource="#session.tramites.dsn#">
				insert into DDVistaGrupo(id_vista, etiqueta, columna, orden, borde, BMfechamod, BMUsucodigo)
					values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="General">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
			</cfquery>
		</cfif>		
</cfif>		
		<cfif isdefined("form.id_tipo") and len(trim(form.id_tipo))>
			<cfquery name="rsVistas" datasource="#session.tramites.dsn#" >
				select 
					a.id_vista,
					a.id_tipo,
					a.nombre_vista,
					a.titulo_vista,
					a.ts_rversion,
					a.vigente_desde,
					a.vigente_hasta,
					a.es_masivo,
					a.es_individual,
					b.es_persona,
					b.nombre_tipo
					
				 from DDVista a
					left outer join DDTipo b
						on b.id_tipo = a.id_tipo
				
				where a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
				<cfif isdefined("form.id_vista") and len(trim(form.id_vista))>
					and id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
				</cfif>
				order by nombre_vista asc
			</cfquery>
		</cfif>
		
		<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
			<TR><TD valign="top" width="100%">
				<cf_web_portlet_start border="true" titulo="Lista de vistas" >
				<cfinclude template="../../../../sif/portlets/pNavegacion.cfm">
				<!--- <table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr><td>&nbsp;</td></tr>
					<tr><td align="right"><a href="listaVista.cfm">Seleccionar una Vista </a>&nbsp;</td></tr>
				</table> --->
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<cfif isdefined("form.id_tipo") and len(trim(form.id_tipo))>
					<tr>
						<td>
							<table align="center" <cfoutput>bgcolor="##CCCCCC"</cfoutput> cellpadding="2" width="100%" cellspacing="3" border="0" style="border:1px solid black">
								<tr> 
									<td style="width:10% ">&nbsp;</td>
									<td  align="right" valign="middle"><font size="-4" color="##003399"><strong>Tipo:&nbsp;</strong></font></td>
									<td align="left" valign="middle"><cfoutput><font size="-1" ><strong>#rsVistas.nombre_tipo#</strong></font></cfoutput></td>
									<td align="right" valign="middle"><font size="-4" color="##003399"><strong>Nombre&nbsp;Vista:&nbsp;</strong></font></td>
									<td align="left" valign="middle"><cfoutput>#rsVistas.nombre_vista#</cfoutput></td>
							      <td rowspan="2" align="right" valign="middle"><font size="-4" color="##003399"><strong>T&iacute;tulo&nbsp;Vista:&nbsp;</strong></font></td> 
								<td align="left" valign="middle"><cfoutput>#rsVistas.titulo_vista#</cfoutput></td>
								</tr>
							</table>
					  </td>
					  </tr></cfif>
						<!--- <cfinclude template="info-empleado.cfm"> --->
					<TR><td>&nbsp;</td></TR>
					<tr><td align="center" valign="top" height="600">
						<cf_tabs width="99%">
							<cf_tab id="1" text="Datos Generales" selected="#form.tab eq 1#">
								
									<cfinclude template="vista_form.cfm"> 
								
							</cf_tab>
							<cfif Len(form.id_tipo)>
								<cfif isdefined("form.id_vista")>
								<cf_tab id="3" text="Grupos" selected="#form.tab eq 3#">
										<cfinclude template="vistaGrupo_form.cfm">
								</cf_tab>
								<cf_tab id="2" text="Campos" selected="#form.tab eq 2#">
										<cfinclude template="vistaDetalle_form.cfm">
								</cf_tab>
								</cfif>
							</cfif>
						</cf_tabs>
					</td>
					</tr>
					<TR><td>&nbsp;</td></TR>
				</table>
				
				<cf_web_portlet_end>
			</TD></TR>
		</table>
		
	</cf_templatearea>
</cf_template>

<script language="JavaScript" type="text/javascript">

</script>
