<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SesionFinalizada" Default="Sesión finalizada" XmlFile="/rh/generales.xml" returnvariable="LB_SesionFinalizada"/>
<cf_importLibs>
<cf_web_portlet_Start>
	<div class="row">
	  <div class="col-lg-12">
	    <div class="bs-example" style="text-align:center;">
	      <div class="jumbotron" style="padding-top:1em;padding-bottom:1em">
	        <h1 style="font-size: 48px;"><cfoutput>#LB_SesionFinalizada#</cfoutput></h1>
	        <cfparam name="url.motivo_cierre" default="T">
	        <p>
	        	<center>
				<div style="font-weight:bold;font-size:24px;font-family:Verdana, Arial, Helvetica, sans-serif;">
				Gracias por su visita</div>
				<br><br><br>

				<div style="width:300px ">
				<cfif url.motivo_cierre is 'K'>
					Su sesión ha sido desconectada por el administrador del sistema. <br>
				<cfelseif url.motivo_cierre is 'L'>
					Gracias por utilizar nuestro portal. Esperamos su próxima visita.<br>
				<cfelseif url.motivo_cierre is 'R'>
					Su sesión ha sido desconectada porque se inició otra sesión utilizando el mismo usuario.<br>
				<cfelseif url.motivo_cierre is 'Y'>
					Su sesión no se ha podido iniciar porque su usuario ya está conectado. Si desea ingresar de nuevo, deberá cerrar la conexión anterior o esperar a que finalice el tiempo de espera de #url.duracion_default# minutos.<br>
				<cfelseif url.motivo_cierre is 'I'>
					Su sesión no se ha podido iniciar porque la cuenta de su empresa está inactiva.<br /><br />Para más detalles contacte con servicio a clientes.<br>
				<cfelse>
					Su sesión ha expirado.<br>
				</cfif>
				</div>
				<br>
				<br>
				</center>
			</p>
	        <p><a href="index.cfm" class="btn btn-primary btn-lg"><i class="fa fa-sign-in"></i> <cf_translate key="LB_IngresarDeNuevo"  xmlFile="/rh/generales.xml">Ingresar de nuevo</cf_translate></a></p>
	      </div>
	    </div>
	  </div>
	</div> 
<cf_web_portlet_end>