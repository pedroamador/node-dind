#!groovy

@Library('github.com/red-panda-ci/jenkins-pipeline-library@develop') _

// Initialize global config
cfg = jplConfig('node-dind', 'backend' ,'', [hipchat: '', slack: '', email: 'redpandaci+node-dind@gmail.com'])

/**

There is an issue with the jplDockerPush helper caused by a bug in Jenkins + Docker plugin

Refs:
JENKINS-31507
JENKINS-44609
JENKINS-44767
JENKINS-44836

We should use bash scripts to build & upload images instead helper until the Jenkins + Plugins issues will be resolved

*/

pipeline {
    agent none

    stages {
        stage ('Initialize') {
            agent { label 'docker' }
            steps  {
                jplStart(cfg)
            }
        }
        stage('Sonar analysis') {
            agent { label 'docker' }
            when { expression { (cfg.BRANCH_NAME == 'develop') || cfg.BRANCH_NAME.startsWith('PR-') } }
            steps {
                // jplSonarScanner(cfg)
                echo "Todo: Execute sonar scanner"
            }
        }
        stage ('Build') {
            agent { label 'docker' }
            steps  {
                //jplDockerPush (cfg, "redpandaci/node-dind", "test", "https://registry.hub.docker.com", "redpandaci-docker-credentials")
                sh "bin/build.sh test; bin/push.sh test"
            }
        }
        stage ('Test') {
            agent { label 'docker' }
            when { expression { (cfg.BRANCH_NAME == 'develop') || cfg.BRANCH_NAME.startsWith('PR-') } }
            steps  {
                sh 'bin/test.sh'
            }
        }
        stage ('Release confirm') {
            when { branch 'release/v*' }
            steps {
                jplPromoteBuild(cfg)
            }
        }

        stage ('Release finish') {
            agent { label 'docker' }
            when { expression { cfg.BRANCH_NAME.startsWith('release/v') && cfg.promoteBuild.enabled } }
            steps {
                //jplDockerPush (cfg, "redpandaci/node-dind", "latest", "https://registry.hub.docker.com", "redpandaci-docker-credentials")
                //jplDockerPush (cfg, "redpandaci/node-dind", tag, "https://registry.hub.docker.com", "redpandaci-docker-credentials")
                sh "bin/build.sh latest; bin/push.sh latest"
                sh "bin/build.sh ${cfg.releaseTagNumber}; bin/push.sh ${cfg.releaseTagNumber}"
                jplCloseRelease(cfg)
            }
        }
        stage ('PR Clean') {
            agent { label 'docker' }
            when { branch 'PR-*' }
            steps {
                deleteDir()
            }
        }
    }

    post {
        always {
            jplPostBuild(cfg)
        }
    }

    options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(artifactNumToKeepStr: '20',artifactDaysToKeepStr: '30'))
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timeout(time: 1, unit: 'DAYS')
    }
}
