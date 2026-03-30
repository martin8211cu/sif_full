<cfoutput>
<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select cb.CBid, m.Mcodigo, m.Mnombre, b.Bid,TESRCBmontoMax,TESRCBmontoMin,
			cb.CBcodigo,cb.CBdescripcion
			from TESreintegroCB a  
			inner join CuentasBancos cb
				on cb.CBid = a.CBid
				and cb.Ecodigo = a.Ecodigo
			inner join Bancos b
				on cb.Bid = b.Bid 
				and cb.Ecodigo = b.Ecodigo
			inner join Monedas m 
				on m.Mcodigo = cb.Mcodigo	
		where a.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
	</cfquery>
	
	<cfset CBid=rsForm.CBid>
	<cfset Mcodigo=rsForm.Mcodigo>
	<cfset CBcodigo=rsForm.CBcodigo>
	<cfset CBdescripcion=rsForm.CBdescripcion>
	<cfset Bid=rsForm.Bid>
	<cfset TESRCBmontoMax=rsForm.TESRCBmontoMax>
	<cfset TESRCBmontoMin =rsForm.TESRCBmontoMin>
<cfelse>
	<cfset Mcodigo=''>
	<cfset CBid=''>
	<cfset CBcodigo=''>
	<cfset CBdescripcion=''>
	<cfset Bid=''>
	<cfset TESRCBmontoMax=''>
	<cfset TESRCBmontoMin =''>
</cfif>

<cfquery datasource="#Session.DSN#" name="rsBancos">
	select Bid as id, Bdescripcion 
	from Bancos 
	where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by Bdescripcion
</cfquery>

<cfform action="catalogoCuentaCorrienteReintegro-SQL.cfm" method="post" name="form1" onSubmit="return validar(this);">
	<table align="center" border="0">
				
		<tr>
			<td>Banco:</td>
			<td>
				<cfset selected="selected">
				<select name="Bid" tabindex="1" onchange="javascript:limpiarCuenta();">
				<option value="">-- Seleccione un Banco --</option>
				<cfloop query="rsBancos">
				<option value="#id#" <cfif #rsBancos.id# eq #Bid#> selected="selected"</cfif>> #Bdescripcion#</option>
				</cfloop>						
				</select>
			</td>
		</tr>
		<tr>
			<td>Cuenta Bancaria:</td>
			<td>
				<cf_conlis title="Lista de Cuentas Bancarias"
				form="form1"
				campos = "CBid, CBcodigo, CBdescripcion, Mcodigo" 
				values="#CBid#,#CBcodigo#,#CBdescripcion#,#Mcodigo#"
				desplegables = "N,S,S,N" 
				modificables = "N,S,N,N" 
				size = "0,10,30,0"
				tabla="CuentasBancos cb
				inner join Monedas m 
				on cb.Mcodigo = m.Mcodigo
				inner join Empresas e
				on e.Ecodigo = cb.Ecodigo
				left outer join Htipocambio tc
				on 	tc.Ecodigo = cb.Ecodigo
				and tc.Mcodigo = cb.Mcodigo
				and tc.Hfecha  <= $fecha,date$
				and tc.Hfechah >  $fecha,date$ "
				columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo, 
				m.Mnombre,
				round(
				coalesce(
				(	case 
				when cb.Mcodigo = e.Mcodigo then 1.00 
				else tc.TCcompra 
				end
				)
				, 1.00)
				,2) as EMtipocambio"
				filtro="cb.Ecodigo = #Session.Ecodigo# and cb.Bid = $Bid,numeric$ order by Mnombre, Hfecha"
				desplegar="CBcodigo, CBdescripcion"
				etiquetas="C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				align="left,left"
				asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre, EMtipocambio"
				asignarformatos="S,S,S,S,S,M"
				showEmptyListMsg="true"
				debug="false"
				tabindex="1">
			</td><br />
		</tr>
	
	
		<tr> 
      		<td nowrap align="right">Monto Maximo:</td>
      		<td>
				<cf_monto name="TESRCBmontoMax" id="TESRCBmontoMax" tabindex="-1" value="#TESRCBmontoMax#" decimales="2" negativos="false">
			</td>
    	</tr>
		
		<tr> 
      		<td nowrap align="right">Monto Minimo:</td>
      		<td>
				<cf_monto name="TESRCBmontoMin" id="TESRCBmontoMin" tabindex="-1" value="#TESRCBmontoMin#" decimales="2" negativos="false">
			</td>
    	</tr>
		
		
      		<td colspan="2">
				<cf_botones modo="#modo#">
			</td>
    	</tr>	
		<tr> 
      		<td colspan="2">
				<input type="hidden" name="modo" value="#modo#" />
				<input type="hidden" name="BMUsucodigo" value="#session.usucodigo#" />
				<input type="hidden" name="Ecodigo" value="#session.Ecodigo#" />
				<input type="hidden" tabindex="1" name="fecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
			</td>
    	</tr>
  	</table>
</cfform>

<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
	
	function validar(){
	document.form1.TESRCBmontoMax.value=qf(	document.form1.TESRCBmontoMax.value);
	document.form1.TESRCBmontoMin.value=qf(	document.form1.TESRCBmontoMin.value);
	}
	
	function limpiarCuenta(){
		objForm.CBid.obj.value="";
		objForm.CBcodigo.obj.value="";
		objForm.CBdescripcion.obj.value="";
	}
</script>
</cfoutput>
