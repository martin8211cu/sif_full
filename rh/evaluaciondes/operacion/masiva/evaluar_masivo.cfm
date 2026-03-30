<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Debe_seleccionar_personas_del_mismo_puesto" 
default="Debe seleccionar personas del mismo puesto." 
component="sif.Componentes.Translate" 
method="Translate"
returnvariable="LB_Mensaje" /> 

<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("url.DEid_LIST") and len(trim(url.DEid_LIST)) and isdefined("form.DEid_LIST")>
	<cfset form.DEid_LIST = url.DEid_LIST>
</cfif>
<cfif isdefined("url.RHEEid") and len(trim(url.RHEEid)) and isdefined("form.RHEEid")>
	<cfset form.RHEEid = url.RHEEid>
</cfif>
<cfif isdefined("url.PCid") and len(trim(url.PCid)) and isdefined("form.PCid")>
	<cfset form.PCid = url.PCid>
</cfif>
<cfif isdefined("url.DEideval") and len(trim(url.DEideval)) and isdefined("form.DEideval")>
	<cfset form.DEideval = url.DEideval>
</cfif>
<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo)) and isdefined("form.RHPcodigo")>
	<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>


<cfif 	isdefined("form.DEid_LIST") 
		and len(trim(form.DEid_LIST)) 
		
		and isdefined("form.RHEEid") 
		and len(trim(form.RHEEid))
		
		and isdefined("form.PCid") 
		and len(trim(form.PCid))
		
		and isdefined("form.DEideval") 
		and len(trim(form.DEideval))

		and isdefined("form.RHPcodigo") 
		and len(trim(form.RHPcodigo))
>
		<cfset RHPcodigo   	= form.RHPcodigo>
		<cfset PCid 	    = form.PCid>
		<cfset DEideval     = form.DEideval>
		<cfset DEid_LIST     = form.DEid_LIST>
		<cfset RHEEid     = form.RHEEid>
		
<cfelse>
	<cfset arreglo = listtoarray(form.CHK,",")>							
	<cfset DEid_LIST   		="">
	<cfset RHEEid    		="">
	<cfset RHPcodigo 		="">
	<cfset RHPcodigo_cant 	= 0>
	<cfset PCid 	    	="">
	<cfset DEideval 		="">
	<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
		<cfset arreglo2 = listtoarray(arreglo[i],"|")>							
		<cfset DEid_LIST 	    = DEid_LIST & arreglo2[1] & ','>
		<cfset RHEEid 	    = arreglo2[2]>
		<cfif RHPcodigo neq arreglo2[3]>
			<cfset RHPcodigo_cant 	= RHPcodigo_cant + 1>
		</cfif>
		<cfset RHPcodigo   	= arreglo2[3]>
		<cfset PCid 	    = arreglo2[4]>
		<cfset DEideval     = arreglo2[5]>
	</cfloop>
	<cfset DEid_LIST 	    = DEid_LIST & '-1'>
	
	<cfif PCid LTE 0 and RHPcodigo_cant gt 1>
		<cf_throw message="#LB_Mensaje#" errorcode="8030">
	</cfif>
</cfif>
<!--- 
		1. Por habilidades: esta opcion significa que por cada habilidad asociada al puesto
							se va a pintar un cuestionario
		2. Por Cuestionario: para esta opcion solo se pinta el cuestionario que se selecciono
		   para la relacion de evaluacion.	
		3. Por Conocimientos: esta opcion significa que por cada conocimiento asociada al puesto
							se va a pintar un cuestionario
		4. Por Habilidades y Conocimientos: esta opcion significa que por cada conocimiento y habilidad asociada al puesto
							se va a pintar un cuestionario
		0 POR CONOCIMIENTOS, -1 POR HABILIDADES, -2 POR HABILIDADES Y CONOCIMIENTOS
--->

<cfif isdefined("PCid") and PCid EQ -1 >
	<cfset tipo_evaluacion = 1 >
<cfelseif isdefined("PCid") and PCid EQ -2>
	<cfset tipo_evaluacion = 4 >
<cfelseif isdefined("PCid") and PCid EQ 0>
	<cfset tipo_evaluacion = 3 >
<cfelse>
	<cfset tipo_evaluacion = 2 >
</cfif>
<cfinclude template="form_evaluar_masivo.cfm">
