<cfif isdefined('form.GELobservaciones')>
	<cfquery datasource="#session.dsn#">
		update GEliquidacion 
			set GELobservaciones=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELobservaciones#">
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>	
</cfif>

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Observación del porque el gasto es mayor a lo calculado">
	<cfoutput>
		<form id="form1" name="form1" method="post" action="LiquidacionAnticiposObs-popUp.cfm">
			<cfif isdefined ('url.GELid') and len(trim(url.GELid))>
				<input type="hidden" name="GELid" value="#url.GELid#" />
			</cfif>	
			<textarea id="GELobservaciones" name="GELobservaciones" cols="50" rows="10" onkeydown="limitaTexto()" onkeyup="limitaTexto()"  > </textarea>
		
         		<p align="center">
					<input name="btnAgregar" value="Guardar y Cerrar" class="btnGuardar" type="submit"/>
				</p>
		</form>
	</cfoutput>
<cf_web_portlet_end>
<cfif isdefined('form.btnAgregar')><script type="text/javascript">window.close();</script></cfif>
<cfoutput>
<script language="javascript">
  function limitaTexto()
{
     num = document.getElementById("GELobservaciones").value.length;
	 tamanyo = 100;
	  if (num > tamanyo) {
	 document.getElementById("GELobservaciones").value =  document.getElementById("GELobservaciones").value.substring(0, tamanyo);
	}	 

	
}
</script></cfoutput>