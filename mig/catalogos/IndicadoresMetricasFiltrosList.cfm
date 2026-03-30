<cfparam name="Attributes.index" default="">
<cfparam name="Attributes.id_oficial" default="">

<cfoutput>
<script>
	function errorHandler(code, msg)
	{
		<cfoutput>
		htmlAdjunto = "<div class='error'><img src='' border=0> "+msg+"</div>";
		</cfoutput>
		document.getElementById("divMensajesX").innerHTML = htmlAdjunto;	
	}	
	
	function CloseThis()
	{<!---cierra la ventana y deja el valor en los campos de la ventana principal--->
		var obj = window.opener.document.getElementById('id_oficial');
		var obj2 = document.formFiltroE.id;
		var obj3 = window.opener.document.getElementById('nombre');
		var obj4 = document.formFiltroE.nombre;
		obj.value = obj2.value;
		obj3.value = obj4.value;
		window.close();	
	}
	
</script>

<cfajaxproxy cfc="../components/oficial"/>
<cfajaximport tags="cfform"/>
<div id="divMensajesX"></div>
<!---lista--->
<table align="center"cellpadding="0" cellspacing="0">
<tr><td>
	<cfform name="formFiltroE"  onsubmit="return false;">
		<cfinput type="hidden" name="id" id="id" bind="{grOficial.id}">
		<cfinput type="hidden" name="nombre" id="nombre" bind="{grOficial.nombre}">
		<table align="center" cellpadding="0" cellspacing="2" bgcolor="E6E6E6">
			<tr><td><strong>Nombre:</strong></td>
				<td>&nbsp;</td>
			</tr><tr>	
				<td><cfinput type="text" name="fnombre" id="fnombre" onChange="ColdFusion.Grid.refresh('grOficial',true);" style="width:200;font-family:Arial, Helvetica, sans-serif; font-size:11px"></td>
				<td><input name="filtrar" value="Filtrar" type="button" onclick="ColdFusion.Grid.refresh('grOficial',true);" /></td>
			</tr>
		</table>
	</cfform>
</td></tr>
<tr><td valign="top">
<cfform name="formEmpleadosList">
	<cfgrid name="grOficial" format="html"  pagesize="15" selectmode="edit"striperows="yes" appendkey="yes" 
		bind="cfc:oficial.getOficial(page={cfgridpage},pagesize={cfgridpagesize},gridsortcolumn={cfgridsortcolumn},gridsortdir={cfgridsortdirection},fnombre={formFiltroE:fnombre})"
		onchange="cfc:oficial.modoCambio({cfgridaction},{cfgridrow},{cfgridchanged})" 
		onError="errorHandler">
		<cfgridcolumn display="no" name="Id" width="40" header=""/>
		<cfgridcolumn name="nombre" header="Nombre" width="200" select="no"/>
		<cfgridcolumn name="activo" header="ACTIVA" values="ACTIVA,INACTIVA" width="70" select="no"/>
   </cfgrid>
</cfform>
</td></tr>

<tr><td align="center">
	<input type="button" name="BTNok" value="OK" onclick="javascript: CloseThis();">
</td></tr>

</table>
</cfoutput>