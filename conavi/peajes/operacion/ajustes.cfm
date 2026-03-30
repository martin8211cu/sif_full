<cfparam name="modo" default="ALTA">
<cfif modo eq 'ALTA' and isdefined('form.BTNEliminar') and isdefined('form.chk') and len(trim(form.chk))>
	<cfset lista = ListToArray(form.chk)>
	<cfloop from="1" to="#ArrayLen(lista)#" index="item">
		<cfinvoke component="conavi.Componentes.ajustes" method="BAJA"
			PAid="#lista[item]#"
			returnvariable="LvarId"				
		/>
	</cfloop>
	<cflocation url="listaAjustes.cfm">
</cfif>
<cfif isdefined('url.PAid') and len(trim('url.PAid'))>
	<cfset form.PAid = #url.PAid#>
</cfif>
<cfif isdefined('url.modo') and len(trim('url.modo'))>
	<cfset modo = #url.modo#>
</cfif>
<cfparam name="modo" default="ALTA">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<!---<cfdump var="#form#">--->
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cfquery name="rsSelectDatosPeajes" datasource="#session.dsn#">
	select p.Pid as id, p.Pcodigo #_Cat# ' - ' #_Cat# p.Pdescripcion as Descripcion
	from Peaje p
	where p.Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsBancos">
	select Bid as BancoId, Bdescripcion as bancoDescripcion
	from Bancos 
	where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by Bdescripcion
</cfquery>

<cfif modo neq 'ALTA' and isdefined('form.PAid') and len(trim('form.PAid'))>
	<cfquery name="rsAjustes" datasource="#session.dsn#">
		select pa.PAid, p.Pid, b.Bid, bt.BTid, pa.PAdocumento, pa.PAdescripcion, pa.PAmonto, 
			pa.PAfecha, m.Mcodigo, m.Mnombre, cb.CBid, cb.CBcodigo, cb.CBdescripcion, 
			coalesce(htc.TCcompra,1) as tipoCambio, pa.ts_rversion
		from PAjustes pa 
			inner join CuentasBancos cb 
				inner join Bancos b 
					on cb.Bid = b.Bid 
					and cb.Ecodigo = b.Ecodigo 
				on cb.CBid = pa.CBid 
				inner join Monedas m 
					on m.Mcodigo = cb.Mcodigo
				 left outer join Htipocambio htc 
					on htc.Mcodigo = m.Mcodigo 
					and htc.Ecodigo = #session.Ecodigo# 
					and pa.PAfecha BETWEEN htc.Hfecha and htc.Hfechah
			inner join Peaje p 
				on p.Pid = pa.Pid 
			inner join BTransacciones bt 
				on bt.BTid = pa.BTid 
		where pa.PAid = <cfqueryparam value="#form.PAid#" cfsqltype="cf_sql_numeric" >
		  and pa.PAestado = 1 
          and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		  and p.Ecodigo = #session.Ecodigo# 
		  order by p.Pcodigo DESC 
	</cfquery>
	<cfset Pid=rsAjustes.Pid>
	<cfset Bid=rsAjustes.Bid>
	<cfset BTid=rsAjustes.BTid>
	<cfset PAdocumento=rsAjustes.PAdocumento>
	<cfset PAdescripcion=rsAjustes.PAdescripcion>
	<cfset PAmonto=rsAjustes.PAmonto>
	<cfset PAfecha=Dateformat(rsAjustes.PAfecha,'dd/mm/yyyy')>
	<cfset Mcodigo=rsAjustes.Mcodigo>
	<cfset Mnombre=rsAjustes.Mnombre>
	<cfset CBid=rsAjustes.CBid>
	<cfset CBcodigo=replace(rsAjustes.CBcodigo,',',' ')>
	<cfset CBdescripcion=replace(rsAjustes.CBdescripcion,',',' ')>
	<cfset tipoCambio=rsAjustes.tipoCambio>
	
<cfelse>
	<cfset Pid="">
	<cfset Bid="">
	<cfset BTid="">
	<cfset PAdocumento="">
	<cfset PAdescripcion="">
	<cfset PAmonto=0.0>
	<cfset PAfecha=Dateformat(now(),'dd/mm/yyyy')>
	<cfset Mcodigo="">
	<cfset Mnombre="">
	<cfset CBid="">
	<cfset CBcodigo="">
	<cfset CBdescripcion="">
	<cfset tipoCambio=1>
	<cfquery name="rsParamCuenta" datasource="#session.dsn#">
	   select Pvalor from Parametros  where Pcodigo = 1804
	</cfquery>	
	<cfif rsParamCuenta.recordcount neq 0 and rsParamCuenta.Pvalor neq ''> <!----Si ya existe una cuenta -------> 					
		<cfset CBid= rsParamCuenta.Pvalor> 
		<cfquery name="rsCuentaBanco" datasource="#session.dsn#">
			Select cb.CBid,cb.CBcodigo,cb.CBdescripcion, b.Bid , m.Mnombre,m.Mcodigo
		   from  CuentasBancos cb 
				inner join Bancos b 
					on cb.Bid = b.Bid 
					and cb.Ecodigo = b.Ecodigo 
				inner join Monedas m 
					on m.Mcodigo = cb.Mcodigo
				  where cb.CBid = #CBid#
                  	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>		
			<cfif rsCuentaBanco.recordcount gt 0>		
				<cfset Bid = rsCuentaBanco.Bid>
				<cfset CBcodigo=rsCuentaBanco.CBcodigo>
				<cfset CBdescripcion=rsCuentaBanco.CBdescripcion> 
				<cfset Mnombre=rsCuentaBanco.Mnombre>
				<cfset Mcodigo=rsCuentaBanco.Mcodigo>
			</cfif>
	</cfif>

</cfif>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Ajustes de Movimientos" skin="#Session.Preferences.Skin#">
<cfoutput>
<cfform action="ajustes_SQL.cfm" method="post" name="form1">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="right" width="50%"><strong>Fecha:</strong></td>
		<td>
			<cf_sifcalendario name="fecha" value="#PAfecha#" tabindex="1">
		</td>
	</tr>
	<tr> 
		<td nowrap align="right"><strong>Peaje:</strong></td>
		<td>
			<select name="selectPeaje">
			<option value="">-- Seleccione un Peaje --</option>
				<cfloop query="rsSelectDatosPeajes">
					<option value="#id#" <cfif Pid eq id> selected="selected"</cfif>>
						#Descripcion#
					</option>
				</cfloop>									
			</select>
		</td>
	</tr>
	<tr>
		<td align="right"><strong>Documento:</strong></td>
		<td>
			<input type="text" name="documento" maxlength="20" value="#PAdocumento#">
		</td>
	</tr>

		<td align="right"><strong>Descripci&oacute;n:</strong></td>
		<td>
			<input type="text" tabindex="1" name="descripcion" maxlength="120" size="40" value="#PAdescripcion#">
		</td>
	</tr>
	<tr>
		<td align="right"><strong>Tipo de Transacci&oacute;n:&nbsp;</strong></td>
		<td>
			<cfquery name="rsBTransacciones" datasource="#session.dsn#">
				select BTid as id, BTcodigo #_Cat#' - '#_Cat# BTdescripcion Descripcion
				from BTransacciones 
				where Ecodigo = #Session.Ecodigo#  
				order by BTid
			</cfquery>
			<select name="BTid">
			<option value="">-- Seleccione una Transacción --</option>
				<cfloop query="rsBTransacciones">
					<option value="#id#" <cfif BTid eq id> selected="selected"</cfif>>
						#Descripcion#
					</option>
				</cfloop>									
			</select>
		</td>
	</tr> 
	<tr>
		<td align="right"><strong>Banco:</strong></td>
		<td>
			<cfset selected="selected">
			<select name="Bid" tabindex="1" onchange="javascript:limpiarCuenta();">
			<option value="">-- Seleccione un Banco --</option>
			<cfloop query="rsBancos">
			<option value="<cfoutput>#BancoId#</cfoutput>" <cfif #Bid# eq #rsBancos.BancoId#> selected="selected"</cfif>><cfoutput>#bancoDescripcion#</cfoutput></option>
			</cfloop>						
			</select>
		</td>
	</tr>
	<tr>
		<td align="right"><strong>Cuenta Bancaria: </strong></td>
		<td>
			<cf_conlis title="Lista de Cuentas Bancarias"
			campos = "CBid, CBcodigo, CBdescripcion, Mcodigo" 
			values="#CBid#,#CBcodigo#,#CBdescripcion#,#Mcodigo#"
			desplegables = "N,S,S,N" 
			modificables = "N,S,N,N" 
			size = "0,0,40,0"
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
			filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 and cb.Bid = $Bid,numeric$ order by Mnombre, Hfecha"
			desplegar="CBcodigo, CBdescripcion"
			etiquetas="C&oacute;digo, Descripci&oacute;n"
			formatos="S,S"
			align="right,right"
			asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre, EMtipocambio"
			asignarformatos="S,S,S,S,S,M"
			showEmptyListMsg="true"
			debug="false"
			tabindex="1">
		</td><br />
	</tr>
	<tr>		
		<td align="right"><strong>Moneda:</strong></td>
		<td><input type="text" name="Mnombre" value="#Mnombre#" readonly tabindex="-1"><br /></td>
	</tr>
	<tr>
		<td align="right"><strong>Tipo de Cambio:</strong></td>
		<td>
			<cf_monto name="EMtipocambio" value="#tipoCambio#" tabindex="-1" decimales="4" size="11">
		</td>	
	</tr>
	<tr>
		<td align="right"><strong>Monto:</strong></td>
		<td>
			<cf_monto name="monto" tabindex="-1" value="#PAmonto#" decimales="2" size="22">
		</td>	
	</tr>
	<tr>
		<td colspan="2">
				<cfset incluir="">
				<cfif modo neq 'ALTA' and isdefined('form.PAid') and len(trim('form.PAid'))>
					<input type="hidden" tabindex="1" name="PAid" value="#form.PAid#">
					<cfset incluir="Aplicar">
				</cfif>
				<cf_botones modo="#modo#" include="#incluir#">
				<cfif modo neq "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsAjustes.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
			</cfif>
		</td>	
	</tr>
</table>
</cfform>

<cf_qforms>

<script language="javascript" type="text/javascript">
	objForm.fecha.description = "#JSStringFormat('Fecha')#";
	objForm.selectPeaje.description = "#JSStringFormat('Peaje')#";
	objForm.documento.description = "#JSStringFormat('Documento')#";
	objForm.BTid.description = "#JSStringFormat('Tipo de Transacción')#";
	objForm.Bid.description = "#JSStringFormat('Banco')#";
	objForm.CBcodigo.description = "#JSStringFormat('Cuenta Bancaria')#";
	objForm.Mnombre.description = "#JSStringFormat('Moneda')#";
	objForm.EMtipocambio.description = "#JSStringFormat('Tipo Cambio')#";
	objForm.monto.description = "#JSStringFormat('Tipo de Transacción')#";
	
	objForm.fecha.required=true;
	objForm.selectPeaje.required=true;
	objForm.documento.required=true;
	objForm.BTid.required=true;
	objForm.Bid.required=true;
	objForm.CBcodigo.required=true;
	objForm.Mnombre.required=true;
	objForm.EMtipocambio.required=true;
	objForm.monto.required=true;
	
	function limpiarCuenta(){
		objForm.CBid.obj.value="";
		objForm.CBcodigo.obj.value="";
		objForm.CBdescripcion.obj.value="";
		objForm.Mcodigo.obj.value="";
		objForm.Mnombre.obj.value="";
		objForm.EMtipocambio.obj.value="";
	}
	
	function funcBaja(){
		<cfif modo neq 'ALTA' and isdefined('form.PAid') and len(trim('form.PAid'))>
			objForm.PAid.required=true;
		</cfif>
		objForm.fecha.required=false;
		objForm.fecha.required=false;
		objForm.selectPeaje.required=false;
		objForm.documento.required=false;
		objForm.BTid.required=false;
		objForm.Bid.required=false;
		objForm.CBcodigo.required=false;
		objForm.Mnombre.required=false;
		objForm.EMtipocambio.required=false;
		objForm.monto.required=false;
	}
	
	function funcNuevo(){
		location.href="ajustes.cfm";
		return false;
	}
</script>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>