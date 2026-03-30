<div class="panel-footer">
	<p><cf_translate key="LB_derechosReservados" xmlFile="/rh/generales.xml">TODOS LOS DERECHOS RESERVADOS</cf_translate>  | SOIN | <cfoutput>#year(now())#</cfoutput></p>
	<img src="/cfmx/plantillas/erp/img/powered_soin.png" width="120" height="21" alt="" class="imgFooter hidden-xs"/>
</div>

<cftry>
<cfquery name="rsTareas" datasource="asp">
	select * from TareasUsuario
	where Usucodigo = #Session.Usucodigo#
	order by Completado asc, Fecha desc
</cfquery>

<script>
	// Open close right sidebar
    $('.right-sidebar-toggle').click(function () {
        $('#right-sidebar').toggleClass('sidebar-open');
    });

	$(function(){
		$('.lobilist-demo').lobiList({
			sortable: false,
			lists: [
		        {
		            title: 'Mis tareas',
		            defaultStyle: 'lobilist-info',
		            controls: ['styleChange'],
		            <cfif rsTareas.recordCount gt 0>
			            <cfset uStr = "">
			            items: [
			            	<cfoutput query="rsTareas">
				                #uStr#
				                {
									id:#rsTareas.tareaid#,
				                    title: '#rsTareas.titulo#',
				                    description: '#rsTareas.descripcion#',
				                    dueDate: '#rsTareas.fecha#'
				                    <cfif rsTareas.completado eq 1>
										,done: true
									</cfif>
				                }
				                <cfset uStr = ",">
			                </cfoutput>
			            ]
		            </cfif>
		        }
		    ],
		    actions: {
			    //'update': '/cfmx/home/Componentes/TareasUsuario.cfc?method=update',
			    //'insert': '/cfmx/home/Componentes/TareasUsuario.cfc?method=insert',
			    //'delete': '/cfmx/commons/Componentes/TareasUsuario.cfc?method=POST'
			},
		    onSingleLine: false,
		    afterListAdd: function(lobilist, list){
		        var $dueDateInput = list.$el.find('form [name=dueDate]');
		        $dueDateInput.datepicker();
		    }
		});

		var instance = $('#todo-lists-demo').data('lobiList');

	});

</script>
<cfcatch>
</cfcatch>
</cftry>

<cfif isdefined("session.flashMessage") and session.flashMessage.message neq "">
	<cfoutput>
		<script>
			$(function() {
				$.notifyBar({
					cssClass: "#session.flashMessage.type#"
					,html: "#session.flashMessage.message#"
				<cfif session.flashMessage.closeOnClick>
					, close: true
					,closeOnClick   : false
					,waitingForClose : true
				</cfif>
				});
		    });
		</script>
	</cfoutput>
	<cfset StructDelete(Session,"flashMessage")>
</cfif>

<!--- <script>
	$(document).on('ready', function() {
		var loader = $("#element").introLoader({
			animation: {
                      name: 'simpleLoader',
                      options: {
                          effect:'slideUp',
                          ease: "easeInOutCirc",
                          style: 'dark',
                          delayTime: 1000, //delay time in milliseconds
                          animationTime: 500

                      }
                  },

                  spinJs: {
                      lines: 13, // The number of lines to draw
                      length: 20, // The length of each line
                      width: 10, // The line thickness
                      radius: 30, // The radius of the inner circle
                      corners: 1, // Corner roundness (0..1)
                      color: '#fff', // #rgb or #rrggbb or array of colors
                  }
		});

	});


</script> --->