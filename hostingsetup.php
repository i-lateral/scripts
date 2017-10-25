<?php
// Once the form is submitted, we setup the server  
if (!empty($_POST)) {
    $return = array();

    // First create bin folder
    $return[] = "Setting up bin dir.";
    if (!file_exists('../scripts')) {
        mkdir('../scripts');
    }

    // Now download and install sake
    $return[] = "Installing Sake...";
    copy("https://raw.githubusercontent.com/silverstripe/silverstripe-framework/3.6/sake", "../scripts/sake");
    chmod("../scripts/sake", 0755);

    // Download and install sspak
    $return[] = "Installing sspak...";
    copy("https://silverstripe.github.io/sspak/sspak.phar", "../scripts/sspak");
    chmod("../scripts/sspak", 0755);

    // Download and install SSPAK backup script
    $return[] = "Installing sspak backup...";
    copy("https://raw.githubusercontent.com/i-lateral/scripts/master/sspaksimplebackup.sh", "../scripts/sspaksimplebackup.sh");
    chmod("../scripts/sspaksimplebackup.sh", 0755);

    // Install Silverstripe deployment script
    $return[] = "Installing deployment script...";
    copy("https://raw.githubusercontent.com/i-lateral/scripts/master/deployment.sh", "../scripts/deployment.sh");
    chmod("../scripts/deployment.sh", 0755);

    // Now add .bash_profile
    $return[] = "Setting up Bash Profile";
    $bash_file = '../.bash_profile';
    $handle = fopen($bash_file, 'w') or die('Cannot open file:  ' . $bash_file);
    $data = 'PATH=$PATH:~/scripts';
    fwrite($handle, $data);
    fclose($handle);

    // Now add _ss_environment
    $return[] = "Adding SS Environment";
    $env_file = '../_ss_environment.php';
    $handle = fopen($env_file, 'w') or die('Cannot open file:  ' . $env_file);
    
    $dbuser = $_POST["dbuser"];
    $dbpass = $_POST["dbpass"];
    $dbname = $_POST["dbname"];
    $defaultdomain = $_POST["defaultdomain"];
    $adminemail = $_POST["adminemail"];
    $adminpass = $_POST["adminpass"];

    $data = "<?php
/* What kind of environment is this: development, test, or live (ie, production)? */
define('SS_ENVIRONMENT_TYPE', 'live');

/* Database connection */
define('SS_DATABASE_SERVER', 'localhost');
define('SS_DATABASE_USERNAME', '$dbuser');
define('SS_DATABASE_PASSWORD', '$dbpass');
define('SS_DATABASE_NAME', '$dbname');

/* Command Line Access */
global \$_FILE_TO_URL_MAPPING;
\$_FILE_TO_URL_MAPPING['/var/www/vhosts/$defaultdomain/httpdocs'] = 'http://$defaultdomain';

/* Configure a default username and password to access the CMS on all sites in this environment. */
define('SS_DEFAULT_ADMIN_USERNAME', '$adminemail');
define('SS_DEFAULT_ADMIN_PASSWORD', '$adminpass');";

    fwrite($handle, $data);
    fclose($handle);

    $return[] = "Setup Complete";

    $result_html = implode($return, "<br/>");
} else {
    $result_html = null;
}

?>

<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    </head>

    <body>
        <div class="container">
            <div class="row">
                <div class="col-md-4 col-md-push-4">
                    <br/>
                    <br/>
                    <div class="panel panel-default">
                        <div class="panel-heading text-center">
                            Prep this server
                        </div>

                        <div class="panel-body">
                            <?php if ($result_html) {
                                echo "<p class=\"alert alert-info\">$result_html</p>";
                            } ?>
                            
                            <form action="hostingsetup.php" method="post">
                                <div class="form-group">
                                    <label for="dbname">What is the DB name?</label>
                                    <input type="text" class="form-control" name="dbname" required>
                                </div>

                                <div class="form-group">
                                    <label for="dbuser">What is the DB username?</label>
                                    <input type="text" class="form-control" name="dbuser" required>
                                </div>

                                <div class="form-group">
                                    <label for="dbpass">What is the DB password?</label>
                                    <input type="password" class="form-control" name="dbpass" required>
                                </div>

                                <div class="form-group">
                                    <label for="adminemail">What is the SS admin email?</label>
                                    <input type="text" class="form-control" name="adminemail" required>
                                </div>

                                <div class="form-group">
                                    <label for="adminpass">What is the SS admin password?</label>
                                    <input type="password" class="form-control" name="adminpass" required>
                                </div>

                                <div class="form-group">
                                    <label for="defaultdomain">What is the default domain (WITHOUT HTTP)?</label>
                                    <input type="text" class="form-control" name="defaultdomain" required>
                                </div>
                                
                                <div class="text-center">
                                    <button type="submit" class="btn btn-primary">Submit</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
