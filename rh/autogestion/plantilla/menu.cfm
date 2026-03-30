<!--- se hace invocación para verificar si el usuario es empleado --->
<cfinvoke component="home.Componentes.Seguridad" returnvariable="datosemp"
method="getUsuarioByCod" tabla="DatosEmpleado" 
Usucodigo="#session.Usucodigo#" Ecodigo="#session.EcodigoSDC#"
/>

<cfset session.monitoreo.forzar = true>
<cfset session.menues.SScodigo = "RH">
<cfset session.menues.SMcodigo = "AUTO">
<cfset session.menues.SPcodigo = "INCIDENCIA">

<cfset DEid = datosemp.llave>
<cfquery name="tieneGestion" datasource="asp">
    select  count(1) as cantidad
    		 from SProcesos a
            inner join SMenues b
                on  a.SScodigo = b.SScodigo
                and	a.SMcodigo = b.SMcodigo
                and	a.SPcodigo = b.SPcodigo	
            inner join SMenues c 	
                on  c.SMNcodigo = b.SMNcodigoPadre
                and c.SMNtitulo ='Gestión del Talento'
            where a.SScodigo = 'RH'
             and a.SMcodigo = 'AUTO'
             and a.SPmenu = 0
            and  b.SMNcodigoPadre is not null
            and a.SPcodigo  in (
                    select b.SPcodigo from SProcesosRol a
                       inner join SProcesos b
                        on a.SPcodigo = b.SPcodigo
                        and b.SPmenu = 0
                        where SRcodigo in (
                        select SRcodigo
                        from UsuarioRol
                        where SRcodigo like '%AUTO%'
                      and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                      and SScodigo = 'RH'
                      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSdc#">
                    )
                )
</cfquery>

<cfset height_Tamano = 150>
<cfif Len(Trim(DEid)) EQ 0>
 	<cfset height_Tamano = height_Tamano + 275>
</cfif>
<cfif  tieneGestion.cantidad eq 0>
 	<cfset height_Tamano = height_Tamano + 158>
</cfif>
<cfif Len(Trim(DEid)) EQ 0 and  tieneGestion.cantidad eq 0>
 	<cfset height_Tamano = 570>
</cfif>

<!---
<cf_template>
<cf_templatearea name="title"><cf_translate key="LB_Autogestion">Autogesti&oacute;n</cf_translate></cf_templatearea>
<cf_templatearea name="body">
--->
<cfset LB_Title="Autogesti&oacute;n">
<cf_templateheader title="#LB_Title#">

<!---
<style type="text/css">
	body{padding: 20px;color: #000e6b;text-align: center;
		font: 85% "Trebuchet MS",Arial,sans-serif}
	h1,h2,h3,p{margin:0;padding:0;font-weight:normal}
	p{padding: 0 10px 15px}
	h1{font-size: 120%;color:#000e6b;letter-spacing: 1px}
	hr{color: #000e6b;}
	h2{font-size: 140%;line-height:1;color:#000e6b }
	div#container{margin: 0 auto;padding:5px;text-align:left;background:#FFFFFF}
	
	div#IZQ{float:right;width:300px;padding:10px 0;margin:5px 0; background:#cce4f9;}
	div#DER{float:right;width:200px;padding:10px 0;margin:5px 0;background: #EEEEEE; }
	div#CENTRO_ARRIBA{clear:both;width:480px;padding:2px 0;margin:5px 0;background:#cce4f9;}
	div#CENTRO_CENTRO{clear:both;width:480px;padding:2px 0;margin:5px 0;background: #cce4f9;}
	div#CENTRO_ABAJO{clear:both;width:480px;background:#cce4f9;padding:2px 0;margin:5px}
</style>

--->
<style type="text/css">
	div#IZQ{float:right;width:300px;padding:10px 0;margin:5px 0; background:#cce4f9;}
	div#DER{float:right;width:200px;padding:10px 0;margin:5px 0;background: #EEEEEE; }
	div#CENTRO_ARRIBA{clear:both;width:480px;padding:2px 0;margin:5px 0;background:#cce4f9;}
	div#CENTRO_CENTRO{clear:both;width:480px;padding:2px 0;margin:5px 0;background: #cce4f9;}
	div#CENTRO_ABAJO{clear:both;width:480px;background:#cce4f9;padding:2px 0;margin:5px}
</style>
<cfset body= 'padding: 20px;color: ##000e6b;text-align: center; font: 85% "Trebuchet MS",Arial,sans-serif'>
<cfset ContainerStyle= "margin: 0 auto;padding:5px;text-align:left;background:##FFFFFF;">
<cfset hStyle="margin:0;padding:0;font-weight:normal;">
<cfset pStyle="#hStyle# padding: 0 10px 15px;">
<cfset hrStyle="color: ##000e6b;">
<cfset h1Style="#hStyle# font-size: 120%;color:##000e6b;letter-spacing: 1px;">
<cfset h2Style="#hStyle# font-size: 140%; line-height:1;color:##000e6b; font-weight: bold;">

<!--- Nifty Corners: incluir css y js --->
<link rel="stylesheet" type="text/css" href="/cfmx/commons/js/niftyCorners.css">
<script type="text/javascript" src="/cfmx/commons/js/nifty.js"></script>
<!--- Nifty Corners: modificar onload para que aplique Rounded(clase, "all/top/bottom", color, backcolor, "small/smooth/border") --->
<script type="text/javascript">
window.onload=function(){
	if(!NiftyCheck())
		return;
	Rounded("div#IZQ",			"all",		"#FFF","#cce4f9","smooth");
	Rounded("div#DER",			"all",		"#FFF","#EEEEEE","smooth");
	Rounded("div#CENTRO_ARRIBA","top",		"#FFF","#cce4f9","smooth");
	Rounded("div#CENTRO_ARRIBA","bottom",	"#FFF","#cce4f9","small");
	Rounded("div#CENTRO_CENTRO","top",		"#FFF","#cce4f9","smooth");
	Rounded("div#CENTRO_CENTRO","bottom",	"#FFF","#cce4f9","small");
	Rounded("div#CENTRO_ABAJO",	"top",		"#FFF","#cce4f9","smooth");
	Rounded("div#CENTRO_ABAJO",	"bottom",	"#FFF","#cce4f9","small");
}
</script>
<cfoutput>
    <div id="container" style="#ContainerStyle#">
        <table width="100%"  border="0" cellpadding="1"  cellspacing="1" style="margin:0">
            <tr>
                <td  valign="top" align="LEFT"style="cursor:pointer" onclick="javascript:location.href='/cfmx/rh/autogestion/plantilla/menu.cfm'">
                    <div id="IZQ">
                        <h2 style="#h2Style#">&nbsp;<cf_translate  key="LB_Autogestion">Autogesti&oacute;n</cf_translate></h2>
                        <hr style="#hrStyle#">
                        <iframe 
                            id="MOD_AUTO" 
                            name="MOD_AUTO" 
                            frameborder="0"  
                            height="570px" 
                            width="300px"  style="border:none"  scrolling="auto"  allowtransparency="yes"
                            src="site_IZQ.cfm" > </iframe>
                    </div>
                </td>
                <td valign="top" align="center">
                    <table width="100%" border="0"  cellpadding="0"  cellspacing="0" style="margin:0" align="center">
                        <cfif  tieneGestion.cantidad neq 0>
                            <tr>
                                <td valign="top" align="center">
                                    <div id="CENTRO_ARRIBA">
                                        <h2 style="#h2Style#">&nbsp;&nbsp;<cf_translate  key="LB_Gestion_del_Talento">Gesti&oacute;n del Talento</cf_translate></h2>
                                        <hr style="#hrStyle#">
                                        <iframe  
                                            id="MOD_AUTO" 
                                            name="MOD_AUTO" 
                                            marginheight="0" 
                                            marginwidth="0" 
                                            frameborder="0" 
                                            height="113px" 
                                            width="480px"  
                                            style="border:none"  scrolling="auto" 
                                            src="site_CENTRO_ARRIBA.cfm" > 
                                        </iframe>
                                    </div>               
                                </td>
                            </tr>
                        </cfif>
                        <cfif Len(Trim(DEid)) NEQ 0>
                            <tr>
                                <td valign="top"  align="center" >
                                    <div id="CENTRO_CENTRO">
                                        <h2 style="#h2Style#">&nbsp;<cf_translate  key="LB_Capacitacion_y_Desarrollo">Capacitaci&oacute;n y Desarrollo</cf_translate></h2>
                                        <hr style="#hrStyle#">
                                        <cfif Len(Trim(DEid)) NEQ 0>
                                            <iframe 
                                                    id="FRAMECJNEGRA" 
                                                    name="FRAMECJNEGRA" 
                                                    marginheight="0" 
                                                    marginwidth="0" 
                                                    frameborder="0" 
                                                    height="205px" 
                                                    width="480px"  style="border:none"  scrolling="auto" 
                                                    src="/cfmx/rh/capacitacion/operacion/automatricula/pantalla.cfm" >                           
                                            </iframe>
                                        </cfif>   
                                    </div>                
                                </td>
                            </tr>
                        </cfif>
                        <tr>
                            <td valign="top" align="center" >
                                <div id="CENTRO_ABAJO">
                                    <h2 style="#h2Style#">&nbsp;<cf_translate  key="LB_Noticias_Y_Avisos">Noticias y Avisos</cf_translate></h2>
                                    <hr style="#hrStyle#">
                                    <iframe 
                                        id="noticas" 
                                        name="noticas" 
                                        marginheight="0" 
                                        marginwidth="0" 
                                        frameborder="0" 
                                        height="#height_Tamano#px" 
                                        width="480px"  style="border:none"  scrolling="auto" 
                                        src="noticias.cfm" >                   
                                    </iframe> 
                                </div>                
                            </td>
                        </tr>
                    </table>    
                </td>
                <td valign="top"  align="right"> 
                    <div id="DER">
                        <table width="100%" cellpadding="0"  cellspacing="0" border="0">
                            <tr>
                                <td valign="top" align="center">
                                    <iframe 
                                        id="noticas" 
                                        name="noticas" 
                                        marginheight="0" 
                                        marginwidth="0" 
                                        frameborder="0" 
                                        height="435px" 
                                        width="200px"  style="border:none"  scrolling="no" 
                                        src="Calendario.cfm" >                   
                                    </iframe>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <h2 style="#h2Style#">&nbsp;<cf_translate  key="LB_Sitios_de_Interes">Sitios de Inter&eacute;s</cf_translate></h2>
                                    <hr style="#hrStyle#">
                                    <iframe 
                                        id="MOD_AUTO2" 
                                        name="MOD_AUTO" 
                                        marginheight="0" 
                                        marginwidth="0" 
                                        frameborder="0" 
                                        height="140px" 
                                        width="200px"  style="border:none"  scrolling="auto" 
                                        src="site_DER.cfm" > 
                                    </iframe>
                                </td>
                            </tr>   
                        </table>
                    </div>    
                </td>
            </tr>
        </table>
    </div>
</cfoutput>
<cf_templatefooter>
<!---
</cf_templatearea>
</cf_template>
--->