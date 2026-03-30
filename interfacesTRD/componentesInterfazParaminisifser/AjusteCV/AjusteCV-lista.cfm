<cfset minisifdb = Application.dsinfo[session.dsn].schema>

<cfquery name="rsACV" datasource="sifinterfaces">
	select a.OCid,a.OCcontrato,a.Producto,a.Modulo,a.OriCosto,a.BMperiodo,a.BMmes,a.Mcodigo,b.Miso4217
	from ACostoVentas a inner join #minisifdb#..Monedas b on a.Ecodigo = b.Ecodigo and a.Mcodigo = b.Mcodigo
	where sessionid = #session.monitoreo.sessionid#
	and BMperiodo <= #periodo#
	and BMmes < #mes#
	order by a.OCcontrato
</cfquery>
<cfif isdefined("periodo") AND isdefined("mes")>
	<cfset Navegacion = "Periodos=#periodo#&Meses=#mes#">
</cfif>	

	<table width="1%" border="0">
		<tr>
			<td nowrap><input type="checkbox" name="chkall" value="T" onClick="javascript:Marcar(this);"></td>
			<td nowrap><strong>Marcar Todos.</strong></td>
		</tr>
	</table>
	<cfinvoke 
	 component="sif.Componentes.pListas"
	 method="pListaQuery"
	 returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsACV#"/>
		<cfinvokeargument name="cortes" value=""/>
		<cfinvokeargument name="desplegar" value="OCcontrato,Producto,Modulo,OriCosto,BMperiodo,BMmes,Miso4217"/>
		<cfinvokeargument name="etiquetas" value="Orden,Producto,Modulo,Monto,Periodo, Mes,Moneda"/>
		<cfinvokeargument name="formatos" value="S,S,S,M,I,I,S"/>
		<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
		<cfinvokeargument name="align" value="left,left,left,right,center,center,Center"/>
		<cfinvokeargument name="lineaRoja" value=""/>
		<cfinvokeargument name="checkboxes" value="S"/>
		<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#?Periodos=#periodo#&Meses=#mes#"/>
		<cfinvokeargument name="MaxRows" value="20"/>
		<cfinvokeargument name="PageIndex" value="1"/>
		<cfinvokeargument name="botones" value="Aplicar,Imprimir,Regresar">
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="showEmptyListMsg" value="True"/>
		<cfinvokeargument name="EmptyListMsg" value="No existen registros a procesar"/>
		<cfinvokeargument name="Keys" value=""/>
		<cfinvokeargument name="Navegacion" value="#Navegacion#"/>

	</cfinvoke>


<script language="JavaScript1.2" type="text/javascript">
function Marcar(c) {
	if (document.lista.chk != undefined) { //existe?
		if (document.lista.chk.value != undefined) {// solo un check
			if (c.checked) document.lista.chk.checked = true; else document.lista.chk.checked = false;
		}
		else {
			for (var counter = 0; counter < document.lista.chk.length; counter++) {
				if (!document.lista.chk[counter].disabled) {
					document.lista.chk[counter].checked = c.checked;
				}
			}
		}
	}
}

function funcAplicar()
{
	if (algunoMarcado())
	{
		if (confirm('¿Confirma aplicar los registros seleccionados a la Poliza de Ajuste de Costo de Ventas?'))
		{<!---document.formwait.style.display = '';--->
			return true;}
		else
		{
			return false;
		}
	}
	else
		return false;
}

function algunoMarcado()
{
	var aplica = false;
	if (document.lista.chk) 
	{
		if (document.lista.chk.value) 
		{
			aplica = document.lista.chk.checked;
		} 
		else 
		{
			for (var i=0; i<document.lista.chk.length; i++) 
			{
				if (document.lista.chk[i].checked) 
				{ 
					aplica = true;
					break;
				}
			}
		}
	}
	if (aplica) 
	{
		return true;
	}
	else 
	{
		alert('Debe seleccionar al menos una Orden antes de Aplicar');
		return false;
	}
}


		//-->
</script>