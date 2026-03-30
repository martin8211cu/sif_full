<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

<cfquery datasource="#session.dsn#" name="rsTES_CFs">
	Select e.Ecodigo,e.Edescripcion
	  from TESempresas te
		inner join Empresas e
			on e.Ecodigo=te.Ecodigo
	 where e.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	order by Edescripcion
</cfquery>

<cfoutput>
<form name="form_TESCFs">
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3" align="left" style="border-bottom: 1px solid black;	padding-bottom: 5px;"><strong>Agregar un nuevo Centro Funcional a la Tesorería</strong></td>
		</tr>				
		<tr>
			<td>&nbsp;</td>
		</tr>				
	
		<tr>
			<td><strong>Empresa:</strong></td>
			<td>
				<cf_navegacion name="CF_Ecodigo" default="-1" session>
				
				<select name="CF_Ecodigo" id="CF_Ecodigo">
					<cfloop query="rsTES_CFs">
						<option value="#rsTES_CFs.Ecodigo#" <cfif rsTES_CFs.Ecodigo EQ form.CF_Ecodigo>selected</cfif>>#rsTES_CFs.Edescripcion#</option>
					</cfloop>
				</select>
			</td>
			<td align="right">
				<input 	type="button" value="Agregar" 
						onclick="
							if (document.form_TESCFs.CF_Ecodigo.value.replace(/\s*/,'') == '')
							{
								alert('El campo Empresa es obligatorio');
								return false;
							} 
							if (document.form_TESCFs.CFid.value.replace(/\s*/,'') == '')
							{
								alert('El campo Centro Funcional es obligatorio');
								return false;
							} 
							sbAltaCFid(document.form_TESCFs.CFid.value);
						">
			</td>
		</tr>
		<tr>
			<td><strong>Centro Funcional:</strong></td>
			<td colspan="2">
					<cf_rhcfuncional 
						form="form_TESCFs" 
						name="CFcodigo"
						desc="CFdescripcion" 
						titulo="Seleccione el Centro Funcional" 
						size="40" excluir="-1" tabindex="1"
						EcodigoName="CF_Ecodigo"
					>
			</td>
		</tr>				
	
		<tr>
			<td>&nbsp;</td>
		</tr>				
		<tr>
			<td colspan="3" align="left" style="border-bottom: 1px solid black;	padding-bottom: 5px;"><strong>Lista de Centros Funcionales que conforman la Tesorería</strong></td>
		</tr>				
	</table>
</form>

<form name="formLista" id="formLista" method="post">
	<input type="hidden" name="TESid" value="#form.TESid#" />
	<table>
		<tr>
			<td>
				&nbsp;&nbsp;&nbsp;
			</td>
			<td>
				<strong>Empresa:</strong>
			</td>
			<td>
				<cf_navegacion name="Filtro_Ecodigo" default="-1" session>
				<select name="Filtro_Ecodigo" id="Filtro_Ecodigo">
					<option value="-1" >(Filtrar por Empresa...)</option>
				<cfloop query="rsTES_CFs">
					<option value="#rsTES_CFs.Ecodigo#" <cfif rsTES_CFs.Ecodigo EQ form.filtro_Ecodigo>selected</cfif>>#rsTES_CFs.Edescripcion#</option>
				</cfloop>
				</select>
			</td>
		</tr>
	</table>
	<cf_dbfunction name="to_char" args="tcf.CFid" datasource="#Session.DSN#" returnvariable="LvarCFid">
	<cfset LvarImgDelete	= "'<img border=''0'' style=''cursor=pointer;'' src=''../../imagenes/Borrar01_S.gif'' onClick=''javascript:sbBajaCFid(' #LvarCNCT# #LvarCFid# #LvarCNCT# ');''>'">
	<cfif form.filtro_Ecodigo NEQ "-1">
		<cfset LvarFiltro_Ecodigo = " and tcf.Ecodigo = #form.filtro_Ecodigo#">
	<cfelse>
		<cfset LvarFiltro_Ecodigo = "">
	</cfif>
    <cf_navegacion name="TESid" navegacion="nave">
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		columnas="
				#LvarImgDelete# as borrar,
				e.Ecodigo,e.Edescripcion, 
				cf.CFcodigo, cf.CFdescripcion, ofi.Oficodigo, tcf.TESid, tcf.CFid
			"
		tabla="
			  TEScentrosFuncionales tcf
				inner join Empresas e
				   on e.Ecodigo = tcf.Ecodigo
				inner join CFuncional cf
					inner join Oficinas ofi
					   on ofi.Ecodigo = cf.Ecodigo
					  and ofi.Ocodigo = cf.Ocodigo
				   on cf.CFid = tcf.CFid
			"
		filtro="tcf.TESid = #form.TESid# #LvarFiltro_Ecodigo# order by e.Edescripcion, cf.CFcodigo"
		desplegar="borrar, CFcodigo, CFdescripcion, Oficodigo"
		cortes="Edescripcion"
		etiquetas=" ,Código, Centro Funcional, Oficina"
		formatos="U,S,S,S"
        Keys="TESid, CFid"
		align="center, left, left, left"
		showlink="no"
        Ira="Tesoreria.cfm"
        PageIndex="2"
        navegacion="#nave#"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		filtrar_por=" , cf.CFcodigo, cf.CFdescripcion, ofi.Oficodigo"
		formName="formLista"
		incluyeForm="no"
	/>
</form>
<script language="javascript" type="text/javascript">
	function sbAltaCFid(CFid)
	{
		location.href = "Tesoreria_sql.cfm?OPaltaCF&TESid=#form.TESid#&CF_Ecodigo="+document.form_TESCFs.CF_Ecodigo.value+"&CFid="+CFid;
	}

	function sbBajaCFid(CFid)
	{
		if ( confirm('¿Desea borrar este Centro Funcional?') ) 
		{
			location.href = "Tesoreria_sql.cfm?OPbajaCF&TESid=#form.TESid#&CF_Ecodigo="+document.form_TESCFs.CF_Ecodigo.value+"&CFid="+CFid;
		}				
	}
</script>
</cfoutput>
