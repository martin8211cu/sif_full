<style>
/* Center the loader */
#loader {
  position: absolute;
  left: 50%;
  top: 50%;
  z-index: 1;
  width: 50px;
  height: 50px;
  margin: -24px 0 0 -24px;
  border: 7px solid #f3f3f3;
  border-radius: 50%;
  border-top: 7px solid #3498db;
  width: 50px;
  height: 50px;
  -webkit-animation: spin 2s linear infinite;
  animation: spin 2s linear infinite;
}

@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Add animation to "page content" */
.animate-bottom {
  position: relative;
  -webkit-animation-name: animatebottom;
  -webkit-animation-duration: 1s;
  animation-name: animatebottom;
  animation-duration: 1s
}

@-webkit-keyframes animatebottom {
  from { bottom:-100px; opacity:0 }
  to { bottom:0px; opacity:1 }
}

@keyframes animatebottom {
  from{ bottom:-100px; opacity:0 }
  to{ bottom:0; opacity:1 }
}

#myDiv {
  display: none;
  text-align: center;
}
</style>
<cfinvoke key="LB_Titulo" default="Ordenes de Pago cargadas desde Importador"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoImportador.xml"/>
<cfquery name="rsDatos" datasource="#session.dsn#">
	select
		NoOrdPago,
		FecGenManual,
		FecPago,
		Referencia
	from
		TESDatosOPImportador
	where IdTransaccion = '#session.idTransaccion#'
</cfquery>

<cf_templateheader title="#LB_Titulo#">
<cfoutput>

<cf_importLibs>

	<form name="form1" action="" onsubmit="">

	<div id="loader"></div>
		<div id="miLista" class="animate-bottom">
			<table style="margin-top: 25px; margin-bottom:25px;" align="center" width="70%" >
				<tr>
					<td>
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							botones="Aplicar"
							returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsDatos#"/>
								<cfinvokeargument name="desplegar" value="NoOrdPago, FecGenManual, FecPago,Referencia"/>
								<cfinvokeargument name="etiquetas" value="No Orden Pago,Fecha Generacion Manual, Fecha Pago, Referencia"/>
								<cfinvokeargument name="formatos" value="S, D, D, S"/>
								<cfinvokeargument name="align" value="right, center, center, left"/>
								<cfinvokeargument name="ajustar" value="N, N, N, N"/>
								<cfinvokeargument name="showLink" value="false">
								<cfinvokeargument name="width" value="80%">
								<cfinvokeargument name="form" value="form1">
								<cfinvokeargument name="showemptylistmsg" value="true"/>
						</cfinvoke>
					</td>
				</tr>
			</table>
		</div>
		</div>
	</form>
</cfoutput>

<cf_templatefooter>
<!--- funAplicar para sobre escribir post de pListas --->
<script language="javascript" type="text/javascript">

	document.getElementById("loader").style.display = "none";
	document.getElementById("miLista").style.display = "initial";

	function funcAplicar()
	{
		document.getElementById("loader").style.display = "initial";
		document.getElementById("miLista").style.display = "block";
		/*
		 * Se bloquea pListas y sus componentes para evitar
		 * multiples ejecuciones de la funcion
		 */
		document.getElementById("miLista").disabled = true;
		var nodes = document.getElementById("miLista").getElementsByTagName('*');
        for(var i = 0; i < nodes.length; i++){
            nodes[i].disabled = true;
        }
		$.ajax({
			type: "POST",
			url: "OrdenesPagoCargadas_sql.cfm",
			data: {'idTransaccion' : 1},
			success: function(obj)
			{
				document.getElementById("loader").style.display = "none";
				document.getElementById("miLista").style.display = "initial";
				$.ajax({
		     		type: "POST",
		     		url: "ajaxValidaOCImportador.cfc?method=getListaErr",
		     		data: {'IdBitacora' : <cfoutput>#(isDefined('session.IdBitacora') ? session.IdBitacora : 0)#</cfoutput>},
		            success: function(obj)
		            {

		            	if(obj == "")
		            	{
		            		document.location = "importadorOrdenesPago.cfm?Completado=OK";
		            	}
		            	else
		            	{
		            		document.getElementById('miLista').innerHTML = obj;
		            	}
		            },
		            error: function(XMLHttpRequest, textStatus, errorThrown) {
		                   alert("Status: " + textStatus); alert("Error: " + errorThrown);
		               }
		    	});
			}
		});
		return false;
	}

	function funDescargar()
	{
		location.href = "../../importar/importar-errores.cfm?hash=<cfoutput>#session.HashB#</cfoutput>&id=<cfoutput>#(isDefined('session.IdBitacora') ? session.IdBitacora : 0)#</cfoutput>";
	}

	function funRegresar()
	{
		document.location = "importadorOrdenesPago.cfm";
	}

</script>
