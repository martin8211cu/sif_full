
<cfquery name="rsMensaje" datasource="asp">
	set nocount on
	if exists(
		select 1 from Buzon 
		where Bcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bcodigo#">
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
		and Bestado = 0
	)
	update Buzon
	set Bestado = 1
	where Bcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bcodigo#">
	and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">

	select convert(varchar, a.Bcodigo) as Bcodigo, 
		   a.Borigen, a.Bdestino, a.Btitulo, a.Bmensaje, 
		   convert(varchar, a.Bfecha, 103) as Bfecha, 
		   substring(convert(varchar, a.Bfecha, 100), charindex(':', convert(varchar, a.Bfecha, 100))-2, 8) as Hora,
		   Bestado,
		   convert(varchar, a.BUsucodigoOr) as BUsucodigoOr,
		   a.BUlocalizacionOr as BUlocalizacionOr
	from Buzon a
	where a.Bcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bcodigo#">
	and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and a.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
	set nocount off
</cfquery>

<cfset dias = "Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo">
<cfset meses = "Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Setiembre, Octubre, Noviembre, Diciembre">
<style type="text/css">
.MessageHeader {
	border-top: 1px solid #666666;
	border-bottom: 1px solid #666666;
	padding: 10px;
	font-weight: bold;
	color: white;
	background-color: #6699CC;
}
</style>
<script language="JavaScript" type="text/javascript">
	function deleteMsg() {
		if (confirm("¿Está seguro de que desear eliminar este mensaje?")) {
			document.lista.O.value = '1';	// Para que el submit vuelva a la pantalla del buzón de entrada
			document.lista.submit();
		}
	}

	function replyMsg() {
		<cfif isdefined("rsMensaje") and rsMensaje.recordCount EQ 1 and Len(Trim(rsMensaje.BUsucodigoOr)) NEQ 0 and Len(Trim(rsMensaje.BUlocalizacionOr)) NEQ 0>
			document.lista.action = 'index.cfm';
			document.lista.O.value = '4';		// Para que el submit vaya a la pantalla para responder un mensaje
			document.lista.submit();
		<cfelse>
			alert("No es posible responder a este mensaje ya que el remitente no fue registrado.");
		</cfif>
	}
</script>

<cfoutput>
	<form name="lista" method="post" action="buzon-action.cfm" onSubmit="return valida();"> 
		<input type="hidden" name="chk" id="chk" value="#Form.Bcodigo#">
		<input type="hidden" name="Bcodigo" id="Bcodigo" value="#Form.Bcodigo#">
		<cfif isdefined("Form.PageNum")>
			<input type="hidden" name="PageNum" id="PageNum" value="#Form.PageNum#">
		</cfif>
		
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2" class="MessageHeader">
		  <tr>
			<td width="1%" align="right" style="padding-left: 10px; padding-right: 10px; font-weight: bold;">De:</td>
			<td class="subrayado" style="padding-right: 10px;">#rsMensaje.Borigen#</td>
		  </tr>
		  <tr>
			<td width="10%" align="right" style="padding-left: 10px; padding-right: 10px; font-weight: bold;">Para:</td>
			<td class="subrayado" style="padding-right: 10px;">#rsMensaje.Bdestino#</td>
		  </tr>
		  <tr>
			<td align="right" style="padding-left: 10px; padding-right: 10px; font-weight: bold;">Asunto:</td>
			<td class="subrayado" style="padding-right: 10px;">#rsMensaje.Btitulo#</td>
		  </tr>
		  <tr>
			<td align="right" style="padding-left: 10px; padding-right: 10px; font-weight: bold;">Fecha:</td>
			<td class="subrayado" style="padding-right: 10px;">#Trim(ListGetAt(dias, DatePart('w', rsMensaje.Bfecha), ','))# #DatePart('d', rsMensaje.Bfecha)# de #Trim(ListGetAt(meses, DatePart('m', rsMensaje.Bfecha), ','))# del #DatePart('yyyy', rsMensaje.Bfecha)# #rsMensaje.Hora#</td>
		  </tr>
		</table>
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td>
				<textarea style="border: none; width: 100%; height: 250px;" readonly>#rsMensaje.Bmensaje#</textarea>
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center"><input name="btnRegresa" type="submit" id="btnRegresa" onClick="javascript: setBtn(this);" value="Buzon de Entrada">
		    <input name="btnBorrar" type="submit" id="btnBorrar" onClick="javascript: setBtn(this);" value="Borrar Mensaje"></td>
		  </tr>		  
		</table>		
	</form>
</cfoutput>

<script language="JavaScript" type="text/javascript">
	var botonActual = "";
	
	function setBtn(obj) {
		botonActual = obj.name;
	}
		
	function valida(){
		if(botonActual == 'btnBorrar'){
			if(!confirm('Realmente desea borrar este mensaje ?')){
				return false;
			}
		}		
		return true;
	}
</script>