<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cffunction name="almacen" returntype="string" >
	<cfargument name="Dcodigo" type="numeric" required="true" default="">
	<cfquery name="desc" datasource="#session.DSN#">
		select Dcodigo, Ddescripcion
		from Departamentos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Dcodigo#">
	</cfquery>
	<cfreturn desc.Dcodigo & '-' & desc.Ddescripcion >
</cffunction>

<cfif isdefined("url.depini") and not isdefined("form.depini")>
	<cfset form.depini = url.depini >
</cfif>
<cfif isdefined("url.depfin") and not isdefined("form.depfin")>
	<cfset form.depfin = url.depfin >
</cfif>

<cfset filtro = ''>
<cfif isdefined("form.depini") and len(trim(form.depini)) and isdefined("form.depfin") and len(trim(form.depfin))>
	<cfif form.depini gt form.depfin >
		<cfset tmp = form.depini>
		<cfset form.depini = form.depfin>
		<cfset form.depfin = tmp >
	</cfif>
	<cfset filtro = "and a.Dcodigo between #form.depini# and #form.depfin#" >
<cfelseif isdefined("form.depini") and len(trim(form.depini)) >
	<cfset filtro = "and a.Dcodigo >= #form.depini# " >
<cfelseif isdefined("form.depfin") and len(trim(form.depfin)) >
	<cfset filtro = "and a.Dcodigo <= #form.depfin# " >
</cfif>

<cfquery name="data" datasource="#session.DSN#">
	select 	
			dA.Pid as identificacionA, (dA.Papellido1 #_Cat# ' ' #_Cat# dA.Papellido2 #_Cat# ' ' #_Cat# dA.Pnombre) as NombreCompletoA,
			dD.Pid as identificacionD, (dD.Papellido1 #_Cat# ' ' #_Cat# dD.Papellido2 #_Cat# ' ' #_Cat# dD.Pnombre) as NombreCompletoD,	
			a.ERid, 
			a.ERdescripcion, 
			a.Aid, 
			b.Bdescripcion, 
			b.Almcodigo,
			a.ERdocumento, 
			a.TRcodigo, 
			c.TRdescripcion, 
			a.Dcodigo, 
			d.Ddescripcion, 
			a.ERFecha
	from HERequisicion a
	inner join Almacen b
	    on a.Aid=b.Aid
	inner join TRequisicion c
	    on a.TRcodigo=c.TRcodigo
	   and a.Ecodigo=c.Ecodigo
	inner join Departamentos d
	    on a.Dcodigo=d.Dcodigo
	   and a.Ecodigo=d.Ecodigo
		
	left outer join Usuario uA
		on uA.Usucodigo = a.UsucodigoA
	left outer join DatosPersonales dA
		on uA.datos_personales = dA.datos_personales	
		
	left outer join Usuario uD
		on uD.Usucodigo = a.UsucodigoD
	left outer join DatosPersonales dD
		on uD.datos_personales = dD.datos_personales
					
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	#filtro#
	order by a.Dcodigo, a.ERFecha
</cfquery>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 1px;
		padding-bottom: 1px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>

<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td colspan="7">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
				<tr><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> 
					<td colspan="4"  valign="middle" align="center"><font size="4"><strong><cfoutput>#session.Enombre#</cfoutput></strong></font></td>
					</strong>
				</tr>
		
				<tr> 
					<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
					<td colspan="4" align="center">
						<font size="3">
							<strong>
								Reporte de Requisiciones por Departamento
							</strong>
						</font>
					</td>
					</strong>
				</tr>

				<cfif isdefined("form.depini") and len(trim(form.depini)) >
					<cfset desde = almacen(form.depini) >
				</cfif>	
				<cfif isdefined("form.depfin") and len(trim(form.depfin)) >
					<cfset hasta = almacen(form.depfin) >
				</cfif>

				<cfoutput>
				<tr > 
					<td colspan="4" align="center">
							<cfif isdefined("desde") and isdefined("hasta")>
								<cfif desde neq hasta >
									<font size="2"><strong>Depto. Inicial:  #desde# - Depto. Final:  #hasta#</strong></font>
								<cfelse>
									<font size="2"><strong>Departamento: #desde#</strong></font>
								</cfif>
							<cfelseif isdefined("desde")>
								<font size="2"><strong>Depto. Inicial: #desde#</strong></font>
							<cfelseif isdefined("hasta")>
								<font size="2"><strong>Depto. Final: #hasta#</strong></font>
							<cfelse>
								<font size="1"><strong>(Todos los Departamentos)</strong></font>
							</cfif>
					</td>
				</tr>
				</cfoutput>
			</table>
		</td>	
	</tr>

	<cfif data.RecordCount gt 0>
		<cfset corte = '' >
		<cfoutput query="data">
			<cfif corte neq data.Dcodigo>
				<tr> 
					<td colspan="7" class="bottomline">&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="7" class="tituloListas" align="left" style="padding-left:3;"><div align="center"><font size="3">#data.Ddescripcion#</font></div></td>
				</tr>
	
				<tr  bgcolor="##B6D0F1" style="padding-left:10; padding:3; "> 
				  <td><strong>Requisici&oacute;n</strong></td>
				  <td><strong>Documento</strong></td>
				  <td><strong>Almac&eacute;n</strong></td>
				  <td><strong>Tipo</strong></td>
				  <td><strong>Fecha</strong></td>
				  <td><strong>Despachado por</strong></td>
				  <td><strong>Aprobado por</strong></td>
				</tr>
			</cfif>
			<tr onClick="javascript:detalle('#data.ERid#');" style="padding-left:10; cursor:hand;" title="Ver detalle de #data.ERdescripcion#" >
				<td nowrap>#data.ERdescripcion#</td>
				<td nowrap>#data.ERdocumento#</td>
				<td nowrap>#trim(data.Almcodigo)# - #data.Bdescripcion#</td>
				<td nowrap>#trim(data.TRcodigo)# - #data.TRdescripcion#</td> 
				<td nowrap>#LSDateFormat(data.ERFecha,'dd/mm/yyyy')#</td>
				<td nowrap>#data.identificacionD# - #data.NombreCompletoD#</td>
				<td nowrap>#data.identificacionA# - #data.NombreCompletoA#</td>
			</tr>
			<cfset corte = data.Dcodigo >
		</cfoutput>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="5" align="center"><strong>------ Fin del Reporte ------</strong></td></tr>
	<cfelse>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="5" align="center"><strong>--- No se encontraron Registros ---</strong></td></tr>
	</cfif>
</table>
<br>

<script language="javascript1.2" type="text/javascript">
	function detalle(ERid){
		location.href = 'DREPReqDepartamento.cfm?ERid='+ERid;
	}
</script>