
<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.GetParametroInfo('30200109')>

<cfif val.codigo eq ''><cfthrow message="El parametro 30200109 no esta definido"></cfif>

<cfoutput> <input type="text" size="60" name="f_30200109" value="#val.Valor#" /> </cfoutput>
