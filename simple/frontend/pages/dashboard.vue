<template>
  <div id="dashboard">
    <v-container
      fluid
      ma-1 pa-1
    >
      <v-layout
        align-space-between 
        justify-start
      >
        <v-flex>
          <!-- Scrollable Panel -->
          <v-container id="scroll-target"
                       ma-0 pa-0
                       class="overflow-y-auto"
          >
            <v-row
              v-scroll:#scroll-target="onScroll"
              align="center"
              justify="center"
            >
              <v-container
                v-for="(record, counter) in latestRecords"
                :key="counter"
                ma-0
                pa-1
              >
                <div class="text-center">
                  <v-sheet
                    class="mx-auto grey lighten-5 title"
                    elevation="1"
                    max-width="900px"
                  >
                    <span class="small black--text">{{ $t(record.title) }}</span>
                    <v-slide-group
                      v-model="model"
                      class="pa-1"
                      :prev-icon="prevIcon ? 'mdi-chevron-left-circle' : undefined"
                      :next-icon="nextIcon ? 'mdi-chevron-right-circle' : undefined"
                      :mandatory="mandatory"
                      :show-arrows="showArrows"
                      :center-active="centerActive"
                    >
                      <v-slide-item
                        v-for="n in 10"
                        :key="n"
                        v-slot:default="{ active, toggle }"
                      >
                        <v-card
                          :color="active ? 'accent' : 'grey lighten-3'"
                          class="ma-1"
                          height="100"
                          width="100"
                          @click="toggle"
                        />
                      </v-slide-item>
                    </v-slide-group>
                  </v-sheet>
                </div>
              </v-container>
            </v-row>
          </v-container>
        </v-flex>
        <v-flex xs4>
          <!-- Right panel -->
          <v-layout ma-0 pa-0>
            <v-flex>
              <v-container ma-0 pa-1 fluid>
                <v-layout column>
                  <v-card class="grey lighten-5">
                    <v-card-title class="small black--text justify-center">
                      {{ $t("DashboardPaidRankingPanelTitle") }}
                    </v-card-title>
                    <v-card-text
                      v-for="(item, n) in paidDekItems"
                      :key="n"
                    >
                      <v-layout align-center>
                        <v-flex xs2>
                          <v-icon large color="grey darken-3">
                            {{ item.icon }}
                          </v-icon>
                        </v-flex>
                        <v-flex>
                          <div class="black--text">
                            {{ item.order }} {{ item.name }}
                          </div>
                          <div class="grey--text">
                            {{ item.desc }}
                          </div>
                        </v-flex>
                        <v-flex xs3>
                          <div class="grey lighten-3 text-center">
                            <span class="grey--text">{{ item.fee }}</span>
                          </div>
                        </v-flex>
                      </v-layout>

                      <!-- <dek-ranking-card
                        icon="mdi-script-text-outline"
                        order="1"
                        name="ScriptReader"
                        desc="Blah blah blah"
                        fee="5000"
                      /> -->
                    </v-card-text>
                    <v-card-actions class="justify-center">
                      <v-btn class="accent flat">
                        {{ $t("DashboardViewMoreRankingPanelButton") }}
                      </v-btn>
                    </v-card-actions>
                  </v-card>
                </v-layout>
              </v-container>
            </v-flex>
          </v-layout>
          <v-layout ma-0 pa-0>
            <v-flex>
              <v-container ma-0 pa-1 fluid>
                <v-layout column>
                  <v-card class="grey lighten-5">
                    <v-card-title class="small black--text justify-center">
                      {{ $t("DashboardFreeRankingPanelTitle") }}
                    </v-card-title>
                    <v-card-text
                      v-for="k in 2"
                      :key="k"
                    />
                    <v-card-actions class="justify-center">
                      <v-btn class="accent flat">
                        {{ $t("DashboardViewMoreRankingPanelButton") }}
                      </v-btn>
                    </v-card-actions>
                  </v-card>
                </v-layout>
              </v-container>
            </v-flex>
          </v-layout>
        </v-flex>
      </v-layout>
    </v-container>
  </div>
</template>

<script>
//import dekRankingCard from "~/components/material/DekRankingCard";

export default {
    component: {
        //dekRankingCard
    },
    data() {
        return {
            paidDekItems: [
                { 
                    icon: "mdi-script-text-outline",
                    order: 1,
                    name: "ScriptReader",
                    desc: "Blah blah blah ...",
                    isPaid: true,
                    fee: 5000
                },
                { 
                    icon: "mdi-motion-sensor",
                    order: 2,
                    name: "MotionDetector",
                    desc: "Blah blah blah ...",
                    isPaid: true,
                    fee: 10000
                },
                { 
                    icon: "mdi-smoke-detector",
                    order: 3,
                    name: "SmokeDetector",
                    desc: "Blah blah blah ...",
                    isPaid: true,
                    fee: 50000
                },
                { 
                    icon: "mdi-eye-settings",
                    order: 4,
                    name: "ScriptReader",
                    desc: "Blah blah blah ...",
                    isPaid: true,
                    fee: 80000
                },
                { 
                    icon: "mdi-eye-outline",
                    order: 5,
                    name: "ScriptReader",
                    desc: "Blah blah blah ...",
                    isPaid: true,
                    fee: 5000
                }
            ],
            latestRecords: [
                {
                    title: "DashboardLatestShowcasesTitle",
                    number: 10
                },
                {
                    title: "DashboardLatestDataTitle",
                    number: 6
                },
                {
                    title: "DashboardLatestPreprocessingTitle",
                    number: 9
                },
                {
                    title: "DashboardLatestModelsTitle",
                    number: 5
                },
                {
                    title: "DashboardLatestVisualizationTitle",
                    number: 12
                },
                {
                    title: "DashboardLatestProcessFlowsTitle",
                    number: 8
                }
            ],
            model: null,
            mandatory: false,
            showArrows: true,
            prevIcon: true,
            nextIcon: true,
            centerActive: true,
            offsetTop: 0
        };
    },
    methods: {
        onScroll (e) {
            this.offsetTop = e.target.scrollTop;
        },
    },
};
</script>

<style lang="scss">
  #dashboard {
    background: rgba(67, 67, 67, 1);

      .v-slide-group__next .v-icon {
    color: rgba(66, 66, 66, 1);
  }

  .v-slide-group__prev .v-icon {
    color: rgba(66, 66, 66, 1);
  }

  }
</style>