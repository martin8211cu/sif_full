<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Filtrar" Default="Filtrar" returnvariable="BTN_Filtrar" xmlfile = "ConceptoGastos.xml"/>

<cfif not isdefined("form.GETid") and isdefined ("url.GETid") and len(trim(url.GETid))>
    <cfset form.GETid = url.GETid>
</cfif>

<cfif not isdefined("form.GELid") and isdefined ("url.GELid") and len(trim(url.GELid))>
    <cfset form.GELid = url.GELid>
</cfif>

<cfif not isdefined("form.formulario") and isdefined ("url.formulario") and len(trim(url.formulario))>
    <cfset form.formulario = url.formulario>
</cfif>

<form style="margin: 0" action="ConceptoGastos.cfm" name="CGastos" id="CGastos" method="post">
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
    <tr>
         <td>
            <!---  Filtro  --->
            <cfoutput>
                <input type="hidden" value="#form.GETid#" 	 name="GETid">
                <input type="hidden" value="#form.GELid#"  name="GELid">
                <input type="hidden" value="#form.formulario#"  name="formulario">
                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                    <tr>
                        <td class="tituloAlterno" align="center"><cf_translate key = LB_ConceptoGastos xmlfile="ConceptoGastos.xml">Concepto de Gastos</cf_translate></td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
                  <tr>
                  	<td width="18" nowrap="" height="17" align="left" class="tituloListas"></td> <td align="left" class="tituloListas">  <table width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td width="100%" align="left">
						<input type="text" value="<cfif isdefined('form.filtro_GECdescripcion')>#form.filtro_GECdescripcion#</cfif>" name="filtro_GECdescripcion" onfocus="this.select()" style="width:100%" maxlength="30" size="6">
					</td>
					<td>
						<table cellspacing="1" cellpadding="0" border="0">
							<tbody>
                            	<tr>
									<td><input type="submit" class="btnFiltrar" value="#BTN_Filtrar#"></td>
								</tr>
							</tbody>
                         </table>
					</td>
				   </tr>
                </table>
            </cfoutput>
        </td>
    </tr>

</table>

	<cfset LvarMaxRows = 25>
    <cfif isdefined ("form.GETid") and form.GETid GT 0>
		<cfset LvarTipo = "PorTipo">
        <cfquery name="rsConceptos" datasource="#Session.DSN#">
            select
                <!--- c.GECdescripcion, --->
				CONCAT(RTRIM(LTRIM(c.GECconcepto)), ' - ', RTRIM(LTRIM(c.GECdescripcion))) AS GECdescripcion,
                c.GECid,
                c.GETid,
                c.GECcomplemento
            from GEconceptoGasto c
                inner join GEtipoGasto t
                    on  c.GETid = t.GETid
            where Ecodigo = #session.Ecodigo#
            and c.GETid= #form.GETid#
            <cfif isdefined ("url.GECid") and url.GECid GT 0>
                and c.GECid=#url.GECid#
            <!---<cfelseif isdefined("url.GEAid")>
                and (
                    select count(1)
                      from GEanticipoDet
                     where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GEAid#">
                       and GECid = c.GECid
                    ) = 0--->
            </cfif>
            <cfif isdefined("form.filtro_GECdescripcion") and len(trim(form.filtro_GECdescripcion))>
            	and upper(CONCAT(RTRIM(LTRIM(c.GECconcepto)), ' - ', RTRIM(LTRIM(c.GECdescripcion)))) like upper('%#form.filtro_GECdescripcion#%')
			</cfif>

        </cfquery>
    <cfelseif isdefined ("form.GETid") and form.GETid LT 0>
        <cfset LvarTipo = "PorImpuesto">
        <cfquery name="rsConceptos" datasource="#Session.DSN#">
            select
                Idescripcion as GECdescripcion,
                Icodigo		 as GECid
            from Impuestos
            where Ecodigo = #session.Ecodigo#
              and Icreditofiscal = 1
              <!--- Solo Impuestos Simples porque SP manual no maneja detalle de impuestos al generar contabilidad --->
              and Icompuesto = 0
              <cfif isdefined("form.filtro_GECdescripcion") and len(trim(form.filtro_GECdescripcion))>
            	and upper(Idescripcion) like upper('%#form.filtro_GECdescripcion#%')
			  </cfif>
              <!--- Solo credito fiscal puro porque solo se digita total y la parte no credito fiscal no se distribuye en las lineas
                    cuando se maneje Compuestos en SP manual, solo pueden ser credito fiscal puro, porque la parte no credito fiscal se debe distribuir entre las lineas
                    tanto en SP manual como en GE.Liq
              and (
                    select count(1)
                      from DImpuestos
                     where Ecodigo = Impuestos.Ecodigo
                       and Icodigo = Impuestos.Icodigo
                       and DIcreditofiscal = 0
                ) = 0
             --->
        </cfquery>
    <cfelse>
        <cfset LvarTipo = "PorAnticipo">
        <cfquery name="rsConceptos" datasource="#Session.DSN#" >
            select distinct
                c.GECdescripcion,
                c.GECid,
                c.GETid,
                c.GECcomplemento
              from GEliquidacionAnts a
                inner join GEanticipoDet b
                    inner join GEconceptoGasto c
                         on c.GECid= b.GECid
                     on b.GEAid = a.GEAid
                    and b.GEADid=a.GEADid
             where a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
             <cfif isdefined("form.filtro_GECdescripcion") and len(trim(form.filtro_GECdescripcion))>
            	and upper(c.GECdescripcion) like upper('%#form.filtro_GECdescripcion#%')
			 </cfif>
             order by c.GECid
        </cfquery>
    </cfif>

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <cfset navegacion = "">
    			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
                    <cfinvokeargument name="query" value="#rsConceptos#">
                    <cfinvokeargument name="columnas" value="GECid,GECdescripcion">
                    <cfinvokeargument name="desplegar" value="GECdescripcion">
                    <cfinvokeargument name="etiquetas" value="">
                    <cfinvokeargument name="formatos" value="S">
                    <cfinvokeargument name="align" value="Left,Left">
                    <cfinvokeargument name="ajustar" value="S">
                    <cfinvokeargument name="showEmptyListMsg" value="true">
                    <cfinvokeargument name="formName" value="CGastos">
                    <cfinvokeargument name="botones" value="Cerrar"/>
                    <cfinvokeargument name="maxrows" value="#LvarMaxRows#"/>
                    <cfinvokeargument name="navegacion" value="#navegacion#"/>
                    <cfinvokeargument name="conexion" value="#session.dsn#"/>
                    <cfinvokeargument name="showEmptyListMsg" value="true"/>
                    <cfinvokeargument name="EmptyListMsg" value="-- No existen Conceptos --"/>
                    <cfinvokeargument name="keys" value="GECid,GECdescripcion"/>
                    <cfinvokeargument name="showLink" value="true">
                    <cfinvokeargument name="fparams" value="GECid,GECdescripcion">
                    <cfinvokeargument name="funcion" value="Procesar"/>
                </cfinvoke>
            </td>
        </tr>
    </table>
</form>


	<script language='javascript' type='text/JavaScript' >
    <!--//
		function Procesar(a,b){
		<cfoutput>
			window.opener.document.#form.formulario#.GECdescripcion.value = b;
			window.opener.document.#form.formulario#.Concepto.value = a;
			window.close();
        </cfoutput>
		}

		function funcCerrar(){
			window.close();
		}
    //-->
    </script>

    <hr width="99%" align="center">



